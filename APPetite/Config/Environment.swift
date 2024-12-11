//
//  Environment.swift
//  APPetite
//
//  Created by Felix Krumme on 10.12.24.
//


//
//  Environment.swift
//  Appetite
//
//  Created by Evelyn Tran on 11/16/24.
//

import Foundation

enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let geminiAPIKey: String = {
        guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
            fatalError("GEMINI_API_KEY not set in environment")
        }
        return apiKey
    }()
    
    static let mealDBBaseURL = "https://www.themealdb.com/api/json/v1/1"
}