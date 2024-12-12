//
//  SearchView.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    let recipes: [Recipe]?
    
    // Default parameter for recipes as nil
    init(recipes: [Recipe]? = nil) {
            self.recipes = recipes
        }
    
    var filteredRecipes: [Recipe] {
        guard let recipes = recipes else { return [] }
        if query.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Search Bar
            SearchBar {newQuery in
                query = newQuery
            }

            Text("\(filteredRecipes.count) Recipes bookmarked")
                .font(.headline)
                .padding(.horizontal)

            // Recipes Grid
            if let recipes = recipes, !recipes.isEmpty {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(filteredRecipes) { recipe in
                            RecipePanel(recipe: recipe)
                                .frame(height: 150)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Spacer()
                Text("No recipes available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.yellow.ignoresSafeArea())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            recipes: [
                Recipe(
                    id: "1",
                    name: "Spaghetti Carbonara",
                    instructions: "",
                    ingredients: [],
                    measures: [],
                    imageURL: "https://www.themealdb.com/images/media/meals/58oia61564916529.jpg"
                ),
                Recipe(
                    id: "2",
                    name: "Pumpkin Soup",
                    instructions: "",
                    ingredients: [],
                    measures: [],
                    imageURL: "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg"
                ),
                Recipe(
                    id: "3",
                    name: "Shrimp Tacos",
                    instructions: "",
                    ingredients: [],
                    measures: [],
                    imageURL: "https://www.themealdb.com/images/media/meals/ryppsv1511815505.jpg"
                )
            ]
        )
    }
}
