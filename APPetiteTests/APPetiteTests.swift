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
        networkManager = RecipeNetworkManager.shared // Use singleton if applicable
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

    func testFetchRandomRecipe() async throws {
        do {
            let recipe = try await networkManager.fetchRandomRecipe()
            XCTAssertNotNil(recipe, "Recipe should not be nil")
            XCTAssertFalse(recipe.name.isEmpty, "Recipe name should not be empty")
        } catch {
            XCTFail("Error fetching random recipe: \(error.localizedDescription)")
        }
    }

    func testSearchRecipes_validQuery() async throws {
        do {
            let recipes = try await networkManager.searchRecipes(query: "Chicken")
            XCTAssertNotNil(recipes, "Recipes should not be nil")
            XCTAssertGreaterThan(recipes.count, 0, "Recipes should not be empty")
        } catch {
            XCTFail("Error searching for recipes: \(error.localizedDescription)")
        }
    }

    func testSearchRecipes_invalidQuery() async throws {
        do {
            let recipes = try await networkManager.searchRecipes(query: "NonExistentRecipe")
            XCTAssertNotNil(recipes, "Recipes should not be nil even for invalid queries")
            XCTAssertEqual(recipes.count, 0, "Recipes count should be 0 for invalid queries")
        } catch {
            XCTFail("Error searching for invalid query: \(error.localizedDescription)")
        }
    }

    func testConvertToRecipe() async throws {
        let mockMeal = MealDBMeal(
            idMeal: "12345",
            strMeal: "Test Meal",
            strInstructions: "Step 1. Do this. Step 2. Do that.",
            strMealThumb: "https://example.com/image.jpg",
            strIngredient1: "Ingredient1",
            strIngredient2: "Ingredient2",
            strIngredient3: "",
            strMeasure1: "1 cup",
            strMeasure2: "2 tbsp",
            strMeasure3: ""
        )

        do {
            let recipe = try await networkManager.convertToRecipe(mockMeal)
            XCTAssertEqual(recipe.id, mockMeal.idMeal, "Recipe ID should match")
            XCTAssertEqual(recipe.name, mockMeal.strMeal, "Recipe name should match")
            XCTAssertEqual(recipe.instructions, mockMeal.strInstructions, "Instructions should match")
            XCTAssertEqual(recipe.ingredients.count, 2, "Ingredients count should match non-empty values")
        } catch {
            XCTFail("Error converting MealDBMeal to Recipe: \(error.localizedDescription)")
        }
    }

    func testSimplifyInstructions() async throws {
        let complexInstructions = """
        1. Preheat oven to 350°F.
        2. Mix ingredients.
        3. Bake for 20 minutes.
        """

        do {
            let simplifiedSteps = try await networkManager.simplifyInstructions(complexInstructions)
            XCTAssertEqual(simplifiedSteps.count, 3, "Should return 3 simplified steps")
            XCTAssertEqual(simplifiedSteps[0], "1. Preheat oven to 350°F.")
            XCTAssertEqual(simplifiedSteps[1], "2. Mix ingredients.")
            XCTAssertEqual(simplifiedSteps[2], "3. Bake for 20 minutes.")
        } catch {
            XCTFail("Error simplifying instructions: \(error.localizedDescription)")
        }
    }

    func testInvalidURL() async throws {
        let invalidManager = RecipeNetworkManager()

        do {
            _ = try await invalidManager.searchRecipes(query: "<InvalidURL>")
            XCTFail("Expected invalid URL error but got success")
        } catch NetworkError.invalidURL {
            XCTAssertTrue(true, "Caught expected invalid URL error")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
