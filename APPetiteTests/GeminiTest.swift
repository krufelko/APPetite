//
//  GeminiTest.swift
//  APPetite
//
//  Created by Evelyn Tran on 12/12/24.
//

import XCTest
import Foundation
@testable import APPetite

final class GeminiTest: XCTestCase {
    var networkManager: RecipeNetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = RecipeNetworkManager.shared
    }
    
    func testGeminiAPI() async throws {
        let testInstructions = "Boil water. Add pasta. Cook for 10 minutes. Drain and serve."
        
        do {
            let steps = try await networkManager.simplifyInstructions(testInstructions)
            XCTAssertFalse(steps.isEmpty, "Steps should not be empty")
            print("Simplified steps: \(steps)")
        } catch {
            XCTFail("Gemini API test failed with error: \(error)")
        }
    }
    
    func testMealDBAPI() async throws {
        do {
            let recipes = try await networkManager.searchRecipes(query: "chicken")
            XCTAssertFalse(recipes.isEmpty, "Should find some recipes")
            print("Found \(recipes.count) recipes")
        } catch {
            XCTFail("MealDB API test failed with error: \(error)")
        }
    }
}
