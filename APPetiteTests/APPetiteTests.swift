//
//  APPetiteTests.swift
//  APPetiteTests
//
//  Created by Felix Krumme on 10.12.24.
//

import XCTest
@testable import APPetite

final class RecipeNetworkManagerTests: XCTestCase {
    var networkManager: RecipeNetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = RecipeNetworkManager()
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

    func testFetchRandomRecipe() async throws {
        do {
            let recipe = try await networkManager.fetchRandomRecipe()
            XCTAssertNotNil(recipe)
            XCTAssertFalse(recipe.name.isEmpty)
        } catch {
            XCTFail("Error fetching random recipe: \(error)")
        }
    }

    func testSearchRecipes_validQuery() async throws {
        do {
            let recipes = try await networkManager.searchRecipes(query: "Chicken")
            XCTAssertNotNil(recipes)
            XCTAssertGreaterThan(recipes.count, 0)
        } catch {
            XCTFail("Error searching for recipes: \(error)")
        }
    }

    func testSearchRecipes_invalidQuery() async throws {
        do {
            let recipes = try await networkManager.searchRecipes(query: "NonExistentRecipe")
            XCTAssertNotNil(recipes)
            XCTAssertEqual(recipes.count, 0)
        } catch {
            XCTFail("Error searching for invalid query: \(error)")
        }
    }

    func testConvertToRecipe() async throws {
        let mockMeal = MealDBMeal(
            idMeal: "12345",
            strMeal: "Test Meal",
            strInstructions: "Step 1. Do this. Step 2. Do that.",
            strMealThumb: "https://example.com/image.jpg"
        )

        do {
            let recipe = try await networkManager.convertToRecipe(mockMeal)
            XCTAssertEqual(recipe.id, mockMeal.idMeal)
            XCTAssertEqual(recipe.name, mockMeal.strMeal)
            XCTAssertEqual(recipe.instructions, mockMeal.strInstructions)
        } catch {
            XCTFail("Error converting MealDBMeal to Recipe: \(error)")
        }
    }

    func testSimplifyInstructions() async throws {
        let complexInstructions = "1. Preheat oven to 350°F. 2. Mix ingredients. 3. Bake for 20 minutes."

        do {
            let simplifiedSteps = try await networkManager.simplifyInstructions(complexInstructions)
            XCTAssertEqual(simplifiedSteps.count, 3)
            XCTAssertEqual(simplifiedSteps[0], "1. Preheat oven to 350°F.")
            XCTAssertEqual(simplifiedSteps[1], "2. Mix ingredients.")
            XCTAssertEqual(simplifiedSteps[2], "3. Bake for 20 minutes.")
        } catch {
            XCTFail("Error simplifying instructions: \(error)")
        }
    }

    func testInvalidURL() async throws {
        let invalidManager = RecipeNetworkManager()

        do {
            _ = try await invalidManager.searchRecipes(query: "<InvalidURL>")
            XCTFail("Expected to throw invalid URL error")
        } catch NetworkError.invalidURL {
            // Success
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
