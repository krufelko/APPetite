

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var query: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Search Bar
                SearchBar { newQuery in
                    query = newQuery
                    viewModel.searchRecipes(query: newQuery) // Trigger search in the view model
                }

                Text("\(viewModel.searchResults.count) Recipes found")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()

                // Recipes Grid
                if !viewModel.searchResults.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.searchResults) { recipe in
                                RecipePanel(recipe: recipe)
                                    .frame(height: 150)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Spacer()
                    Text("")
                }
            }
            .background(Color.yellow.ignoresSafeArea())
            .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
