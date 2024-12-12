//
//  HomeView.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    Text("Hey Chef!")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    // "Recipes just for you" section
                    SectionView(title: "Recipes just for you") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                if let error = viewModel.errorMessage {
                                Group {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            } else if viewModel.randomRecipes.isEmpty {
                                ForEach(0..<10, id: \.self) { _ in
                                    Group {
                                        RecipePanel(recipe: Recipe(
                                            id: "0",
                                            name: "Loading...",
                                            instructions: "",
                                            ingredients: [],
                                            measures: [],
                                            imageURL: ""
                                        ))
                                        .opacity(0.5) // Grayed out appearance
                                        .disabled(true) // Ensures the panel is non-interactive
                                    }
                                }
                            } else {
                                ForEach(viewModel.randomRecipes, id: \.id) { recipe in
                                    RecipePanel(recipe: recipe)
                                }
                            }
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
                            ingredients: ["Spaghetti", "Eggs", "Parmesan Cheese", "Bacon"],
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
                            ingredients: ["Pineapple"],
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
            .onAppear {
                            viewModel.fetchRandomRecipes(count: 10)
                        }
        }
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
