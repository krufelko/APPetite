//
//  GeminiTest.swift
//  APPetite
//
//  Created by Evelyn Tran on 12/12/24.
//

import XCTest
import Foundation
import GoogleGenerativeAI
@testable import APPetite

final class GeminiTest: XCTestCase {
    var networkManager: RecipeNetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = RecipeNetworkManager.shared
    }
    
    func testGeminiAPI() async throws {
        let expectation = expectation(description: "Test Gemini API")
        
        do {
            print("Testing Gemini API with simple instruction...")
            let testInstructions = "Boil water. Add pasta. Cook for 10 minutes. Drain and serve."
            let steps = try await networkManager.simplifyInstructions(testInstructions)
            
            XCTAssertFalse(steps.isEmpty, "Steps should not be empty")
            print("Simplified steps: \(steps)")
            
            expectation.fulfill()
        } catch {
            XCTFail("API test failed with error: \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 30.0)
    }
    
    func testMealDBAPI() async throws {
        let expectation = expectation(description: "Test MealDB API")
        
        do {
            print("Testing MealDB API...")
            let recipes = try await networkManager.searchRecipes(query: "chicken")
            
            XCTAssertFalse(recipes.isEmpty, "Should find some recipes")
            print("Found \(recipes.count) recipes")
            
            expectation.fulfill()
        } catch {
            XCTFail("API test failed with error: \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 30.0)
    }
}
