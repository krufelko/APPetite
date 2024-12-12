
import SwiftUI

struct ShoppingListView: View {
    @StateObject private var viewModel = RecipeIngredientManager()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.ingredients.isEmpty {
                    Text("No ingredients saved yet.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.ingredients.keys.sorted(), id: \ .self) { recipeID in
                            Section(header: Text(recipeID)) {
                                if let recipeIngredients = viewModel.ingredients[recipeID] {
                                    ForEach(recipeIngredients) { ingredient in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(ingredient.name)
                                                    .font(.headline)
                                                Text(ingredient.quantity)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                        }
                                    }
                                    .onDelete { indexSet in
                                        indexSet.forEach { index in
                                            let ingredient = recipeIngredients[index]
                                            viewModel.removeIngredient(from: recipeID, ingredient: ingredient)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ingredients")
            .onAppear {
                viewModel.loadIngredients() // Reload ingredients every time the view appears
            }
            .toolbar {
                EditButton() // Allows the list to be editable
            }
        }
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
