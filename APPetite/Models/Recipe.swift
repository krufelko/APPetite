//
//  Recipe.swift
//  APPetite
//
//  Created by Felix Krumme on 10.12.24.
//


//
//  Recipe.swift
//  Appetite
//
//  Created by Evelyn Tran on 11/16/24.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [String]
    let measures: [String]
    let imageURL: String
    var simplifiedSteps: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case imageURL = "strMealThumb"
    }
}

struct MealDBResponse: Codable {
    let meals: [MealDBMeal]?
}

struct MealDBMeal: Codable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    
    private enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb
    }
}