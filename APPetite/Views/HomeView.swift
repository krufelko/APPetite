//
//  HomeView.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Hey Chef!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                // Search Bar
                SearchBar()
                    .padding(.horizontal)

                // "Recipes just for you" section
                SectionView(title: "Recipes just for you") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            RecipePanel(recipe: Recipe(
                                id: "1",
                                name: "Scrambled Eggs",
                                instructions: "Quick and easy scrambled eggs.",
                                ingredients: [],
                                measures: [],
                                imageURL: "https://www.themealdb.com/images/media/meals/58oia61564916529.jpg"
                            ))
                            RecipePanel(recipe: Recipe(
                                id: "2",
                                name: "Breakfast Burritos",
                                instructions: "A delicious breakfast burrito.",
                                ingredients: [],
                                measures: [],
                                imageURL: "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg"
                            ))
                        }
                        .padding(.horizontal)
                    }
                }

                // "Cook again" section
                SectionView(title: "Cook again") {
                    RecipePanel(recipe: Recipe(
                        id: "3",
                        name: "Spaghetti Carbonara",
                        instructions: "Classic Italian pasta dish.",
                        ingredients: [],
                        measures: [],
                        imageURL: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"
                    ))
                    .padding(.horizontal)
                }

                // "Continue Recipe" section
                SectionView(title: "Continue Recipe") {
                    RecipePanel(recipe: Recipe(
                        id: "4",
                        name: "Lemon Bars",
                        instructions: "A tart and sweet dessert.",
                        ingredients: [],
                        measures: [],
                        imageURL: "https://www.themealdb.com/images/media/meals/ryppsv1511815505.jpg"
                    ))
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.vertical)
        }
        .background(Color.yellow.ignoresSafeArea())
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)

            content()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
