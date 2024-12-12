
//  RecipeNetworkManager.swift
//  Appetite
//
//  Created by Evelyn Tran on 11/16/24.
//

import Foundation
import GoogleGenerativeAI

// MARK: - Logging
enum LogLevel {
    case debug
    case info
    case error
}

// MARK: - Network Error
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case decodingError
    case apiError(String)
}

// MARK: - RecipeNetworkManager
final class RecipeNetworkManager {
    static let shared = RecipeNetworkManager()
    private let baseURL = Environment.mealDBBaseURL
    private let genAI: GenerativeModel
    private let urlSession: URLSession
    
    // Custom logging function
    private func log(_ message: String, level: LogLevel = .info) {
        #if DEBUG
        let prefix: String
        switch level {
        case .debug: prefix = "🔍 DEBUG:"
        case .info:  prefix = "ℹ️ INFO:"
        case .error: prefix = "⚠️ ERROR:"
        }
        print("\(prefix) \(message)")
        #endif
    }
    
    init() {
        // Configure URL Session with longer timeouts
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        self.urlSession = URLSession(configuration: configuration)
        
        // Initialize Gemini with proper error handling
        self.genAI = GenerativeModel(name: "gemini-pro", apiKey: Environment.geminiAPIKey)
        
        // Log initialization
        log("RecipeNetworkManager initialized with Gemini API", level: .debug)
    }
    
    // Fetch random recipe from the MealDB API
    public func fetchRandomRecipe() async throws -> Recipe {
        let endpoint = "\(baseURL)/random.php"
        guard let url = URL(string: endpoint) else {
            log("Invalid URL: \(endpoint)", level: .error)
            throw NetworkError.invalidURL
        }
        
        do {
            log("Fetching random recipe...", level: .debug)
            let (data, apiResponse) = try await urlSession.data(from: url)
            
            guard let httpResponse = apiResponse as? HTTPURLResponse else {
                log("Invalid response type", level: .error)
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                log("Server error: \(httpResponse.statusCode)", level: .error)
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let mealDBResponse = try decoder.decode(MealDBResponse.self, from: data)
            
            guard let mealDBMeal = mealDBResponse.meals?.first else {
                log("No data returned from API", level: .error)
                throw NetworkError.noData
            }
            
            log("Successfully fetched random recipe", level: .debug)
            return try await convertToRecipe(mealDBMeal)
        } catch {
            log("API Error: \(error.localizedDescription)", level: .error)
            throw NetworkError.apiError("MealDB API Error: \(error.localizedDescription)")
        }
    }
    
    // Search recipes by name
    public func searchRecipes(query: String) async throws -> [Recipe] {
        let endpoint = "\(baseURL)/search.php?s=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: endpoint) else {
            log("Invalid URL: \(endpoint)", level: .error)
            throw NetworkError.invalidURL
        }
        
        do {
            log("Searching recipes with query: \(query)", level: .debug)
            let (data, apiResponse) = try await urlSession.data(from: url)
            
            guard let httpResponse = apiResponse as? HTTPURLResponse else {
                log("Invalid response type", level: .error)
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                log("Server error: \(httpResponse.statusCode)", level: .error)
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let mealDBResponse = try decoder.decode(MealDBResponse.self, from: data)
            
            guard let meals = mealDBResponse.meals else {
                log("No recipes found", level: .info)
                return []
            }
            
            // Convert meals to recipes with unique IDs
            let recipes = try await withThrowingTaskGroup(of: Recipe.self) { group in
                var results: [Recipe] = []
                var usedIds = Set<String>()
                
                for meal in meals {
                    if !usedIds.contains(meal.idMeal) {
                        group.addTask {
                            try await self.convertToRecipe(meal)
                        }
                        usedIds.insert(meal.idMeal)
                    }
                }
                
                for try await recipe in group {
                    results.append(recipe)
                }
                return results
            }
            
            log("Found \(recipes.count) recipes", level: .debug)
            return recipes
            
        } catch {
            log("API Error: \(error.localizedDescription)", level: .error)
            throw NetworkError.apiError("MealDB API Error: \(error.localizedDescription)")
        }
    }
    
    // Convert MealDBMeal to Recipe and simplify instructions
    public func convertToRecipe(_ meal: MealDBMeal) async throws -> Recipe {
        log("Converting meal to recipe: \(meal.strMeal)", level: .debug)
        
        // Extract ingredients and measures using reflection
        let mirror = Mirror(reflecting: meal)
        var ingredients: [String] = []
        var measures: [String] = []
        
        for case let (label?, value) in mirror.children {
            if label.starts(with: "strIngredient"),
               let ingredient = value as? String,
               !ingredient.isEmpty && ingredient != " " {
                ingredients.append(ingredient)
            }
            if label.starts(with: "strMeasure"),
               let measure = value as? String,
               !measure.isEmpty && measure != " " {
                measures.append(measure)
            }
        }
        
        // Simplify recipe instructions using Gemini API
        let simplifiedSteps = try await simplifyInstructions(meal.strInstructions)
        
        log("Successfully converted recipe", level: .debug)
        return Recipe(
            id: meal.idMeal,
            name: meal.strMeal,
            instructions: meal.strInstructions,
            ingredients: ingredients,
            measures: measures,
            imageURL: meal.strMealThumb,
            simplifiedSteps: simplifiedSteps
        )
    }
    
    // Simplify instructions using Gemini API
    public func simplifyInstructions(_ instructions: String) async throws -> [String] {
        log("Simplifying instructions using Gemini API", level: .debug)
        
        let prompt = """
        Convert these cooking instructions into simple, short, step-by-step instructions. 
        Return only the numbered steps, one per line:
        \(instructions)
        """
        
        do {
            log("Sending request to Gemini API...", level: .debug)
            let geminiResponse = try await genAI.generateContent(prompt)
            
            guard let simplifiedText = geminiResponse.text, !simplifiedText.isEmpty else {
                log("Empty response from Gemini API", level: .error)
                throw NetworkError.apiError("Generated response text is empty")
            }
            
            log("Received response from Gemini API", level: .debug)
            
            // Split and clean up the response
            let steps = simplifiedText
                .components(separatedBy: CharacterSet.newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
                .map { step in
                    // Remove number prefix if present
                    if let range = step.range(of: #"^\d+\.\s*"#, options: .regularExpression) {
                        return String(step[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                    }
                    return step
                }
            
            log("Successfully simplified instructions into \(steps.count) steps", level: .debug)
            return steps
            
        } catch {
            log("Gemini API Error: \(error)", level: .error)
            throw NetworkError.apiError("Gemini API Error: \(error.localizedDescription)")
        }
    }
}
