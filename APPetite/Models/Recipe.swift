
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
    var simplifiedSteps: [String] = [] // Default value
    var isBookmarked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case imageURL = "strMealThumb"
        case ingredients, measures // Explicitly mark these as not mapped from JSON
    }
    
    public mutating func setIsBookmarked(value: Bool) {
        self.isBookmarked = value
    }
}
