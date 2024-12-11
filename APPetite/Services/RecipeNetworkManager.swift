//
//  RecipeNetworkManager.swift
//  APPetite
//
//  Created by Felix Krumme on 10.12.24.
//


//
//  RecipeNetworkManager.swift
//  Appetite
//
//  Created by Evelyn Tran on 11/16/24.
//

import Foundation
import GoogleGenerativeAI

class RecipeNetworkManager {
    static let shared = RecipeNetworkManager()
    private let baseURL = Environment.mealDBBaseURL
    private let genAI = GoogleGenerativeAI(apiKey: Environment.geminiAPIKey)
    
    private init() {}
    
    // Fetch random recipe from the MealDB API
    func fetchRandomRecipe() async throws -> Recipe {
        let endpoint = "\(baseURL)/random.php"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealDBResponse.self, from: data)
        
        guard let mealDBMeal = response.meals?.first else {
            throw NetworkError.noData
        }
        
        return try await convertToRecipe(mealDBMeal)
    }
    
    // Search recipes by name
    func searchRecipes(query: String) async throws -> [Recipe] {
        let endpoint = "\(baseURL)/search.php?s=\(query)"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealDBResponse.self, from: data)
        
        guard let meals = response.meals else {
            return []
        }
        
        // Convert all meals to recipes in parallel
        let recipes = try await withThrowingTaskGroup(of: Recipe.self) { group in
            for meal in meals {
                group.addTask {
                    try await self.convertToRecipe(meal)
                }
            }
            
            var results: [Recipe] = []
            for try await recipe in group {
                results.append(recipe)
            }
            return results
        }
        
        return recipes
    }
    
    // Convert MealDBMeal to Recipe and simplify instructions
    private func convertToRecipe(_ meal: MealDBMeal) async throws -> Recipe {
        // Extract ingredients and measures using reflection
        let mirror = Mirror(reflecting: meal)
        var ingredients: [String] = []
        var measures: [String] = []
        
        for case let (label?, value) in mirror.children {
            if label.starts(with: "strIngredient"),
               let ingredient = value as? String,
               !ingredient.isEmpty {
                ingredients.append(ingredient)
            }
            if label.starts(with: "strMeasure"),
               let measure = value as? String,
               !measure.isEmpty {
                measures.append(measure)
            }
        }
        
        // Simplify recipe instructions to one line, short instructions using Gemini API
        let simplifiedSteps = try await simplifyInstructions(meal.strInstructions)
        
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
    
    // This is the system prompt we used to get Gemini to break down the instructions from the MealDB API into a step-by-step format
    private func simplifyInstructions(_ instructions: String) async throws -> [String] {
        let model = genAI.generateContent()
        let prompt = """
        Convert these cooking instructions into simple, short, step-by-step instructions. 
        Return only the numbered steps, one per line:
        \(instructions)
        """
        
        let response = try await model.generate(prompt: prompt)
        let simplifiedText = response.text ?? ""
        
        // Split the response into an array of steps
        return simplifiedText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}

// MARK: - Error Handling
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case apiError(String)
}