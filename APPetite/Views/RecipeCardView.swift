import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    @State private var isIngredientsExpanded: Bool = false
    @State private var isInstructionsExpanded: Bool = false
    @State private var isSheetPresented: Bool = false
    @ObservedObject var bookmarkManager = RecipeBookmarkManager()
    @SwiftUI.Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Recipe Image
                    AsyncImage(url: URL(string: recipe.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.3)
                                .frame(height: 200)
                                .cornerRadius(12)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
                        case .failure(_):
                            Color.gray
                                .frame(height: 200)
                                .cornerRadius(12)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Recipe Details
                        HStack {
                            Text("easy")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("15 min")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(recipe.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        // Ingredients Section
                        DisclosureGroup(isExpanded: $isIngredientsExpanded) {
                            ForEach(Array(zip(recipe.ingredients, recipe.measures)), id: \.0) { ingredient, measure in
                                HStack {
                                    Text(ingredient)
                                    Spacer()
                                    Text(measure)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        } label: {
                            Text("Ingredients")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // Instructions Section
                        DisclosureGroup(isExpanded: $isInstructionsExpanded) {
                            ForEach(recipe.simplifiedSteps.indices, id: \.self) { index in
                                Text("\(index + 1). \(recipe.simplifiedSteps[index])")
                                    .padding(.vertical, 4)
                            }
                        } label: {
                            Text("Instructions")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                }
                .cornerRadius(16)
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            
            // Call to Action Button
            Button(action: {
                // Example action for the "Let's cook" button
            }) {
                Text("Let's cook")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .padding(.trailing, 8)
                        }
                    )
            }
            .foregroundColor(.black)
            .padding()
        }
        .toolbar {
            // Dismiss button for full-screen view
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss() // Dismisses the full-screen view
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSheetPresented = true
                }) {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack {
                Button(action: {
                    bookmarkManager.addBookmark(recipe)
                    isSheetPresented = false
                }) {
                    Text("Add to Bookmarks")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    // Action for adding to shopping list
                }) {
                    Text("Add to Shopping List")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    isSheetPresented = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
