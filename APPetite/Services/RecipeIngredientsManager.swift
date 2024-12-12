//
//  RecipeIngredientsManager.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import Foundation
import Combine

class RecipeIngredientManager: ObservableObject {
    @Published private(set) var ingredients: [String: [Ingredient]] = [:] // Dictionary to map recipe IDs to ingredient lists
    private let ingredientsKey = "recipeIngredients"
    
    init() {
        loadIngredients()
    }
    
    /// Loads ingredients from UserDefaults
    func loadIngredients() {
        if let data = UserDefaults.standard.data(forKey: ingredientsKey) {
            do {
                let decodedIngredients = try JSONDecoder().decode([String: [Ingredient]].self, from: data)
                ingredients = decodedIngredients
            } catch {
                print("Failed to decode ingredients: \(error.localizedDescription)")
            }
        }
    }
    
    /// Saves the current ingredients to UserDefaults
    func saveIngredients() {
        do {
            let data = try JSONEncoder().encode(ingredients)
            UserDefaults.standard.set(data, forKey: ingredientsKey)
        } catch {
            print("Failed to save ingredients: \(error.localizedDescription)")
        }
    }
    
    /// Adds a new ingredient to a recipe
    /// - Parameters:
    ///   - recipeID: The ID of the recipe to which the ingredient belongs
    ///   - ingredient: The ingredient to add
    func addIngredient(to recipeID: String, ingredient: Ingredient) {
        if ingredients[recipeID] == nil {
            ingredients[recipeID] = []
        }
        
        if !ingredients[recipeID]!.contains(where: { $0.id == ingredient.id }) {
            ingredients[recipeID]!.append(ingredient)
            saveIngredients()
        }
    }
    
    /// Removes an ingredient from a recipe
    /// - Parameters:
    ///   - recipeID: The ID of the recipe from which the ingredient should be removed
    ///   - ingredient: The ingredient to remove
    func removeIngredient(from recipeID: String, ingredient: Ingredient) {
        ingredients[recipeID]?.removeAll(where: { $0.id == ingredient.id })
        saveIngredients()
    }
    
    /// Checks if an ingredient exists for a specific recipe
    /// - Parameters:
    ///   - recipeID: The ID of the recipe
    ///   - ingredient: The ingredient to check
    /// - Returns: `true` if the ingredient exists for the recipe, otherwise `false`
    func hasIngredient(for recipeID: String, ingredient: Ingredient) -> Bool {
        return ingredients[recipeID]?.contains(where: { $0.id == ingredient.id }) ?? false
    }
    
    /// Retrieves all ingredients for a specific recipe
    /// - Parameter recipeID: The ID of the recipe
    /// - Returns: An array of ingredients for the recipe
    func getIngredients(for recipeID: String) -> [Ingredient] {
        return ingredients[recipeID] ?? []
    }
}

/// Example Ingredient struct
struct Ingredient: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let quantity: String
}
