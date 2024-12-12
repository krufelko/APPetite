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
        if let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] {
            return apiKey
        }
        // Fallback to check Info.plist
        if let apiKey = infoDictionary["GEMINI_API_KEY"] as? String {
            return apiKey
        }
        fatalError("GEMINI_API_KEY not found in environment or Info.plist")
    }()
    
    static let mealDBBaseURL = "https://www.themealdb.com/api/json/v1/1"
}
