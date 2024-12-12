//
//  RecipeViewModel.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var randomRecipe: Recipe?
    @Published var errorMessage: String?
    @Published var searchResults: [Recipe] = []
    @Published var randomRecipes: [Recipe] = []
    
    private var recipeNetworkManager = RecipeNetworkManager()

    // Fetch random recipe
    func fetchRandomRecipe() {
        Task {
            do {
                randomRecipe = try await recipeNetworkManager.fetchRandomRecipe()
            } catch {
                errorMessage = "Failed to fetch recipe: \(error.localizedDescription)"
            }
        }
    }

    // Fetch n random recipes
        func fetchRandomRecipes(count: Int) {
            Task {
                do {
                    var recipes: [Recipe] = []
                    for _ in 0..<count {
                        let recipe = try await recipeNetworkManager.fetchRandomRecipe()
                        recipes.append(recipe)
                    }
                    randomRecipes = recipes
                } catch {
                    errorMessage = "Failed to fetch random recipes: \(error.localizedDescription)"
                }
            }
        }
    
    // Search recipes by name
    func searchRecipes(query: String) {
        Task {
            do {
                searchResults = try await recipeNetworkManager.searchRecipes(query: query)
            } catch {
                errorMessage = "Failed to search recipes: \(error.localizedDescription)"
            }
        }
    }

    // Simplify instructions for a recipe
    func simplifyInstructions(for recipe: Recipe) async throws -> [String] {
        do {
            return try await recipeNetworkManager.simplifyInstructions(recipe.instructions)
        } catch {
            throw error
        }
    }

    // Convert MealDBMeal to Recipe
    func convertToRecipe(meal: MealDBMeal) async throws -> Recipe {
        do {
            return try await recipeNetworkManager.convertToRecipe(meal)
        } catch {
            throw error
        }
    }
}
