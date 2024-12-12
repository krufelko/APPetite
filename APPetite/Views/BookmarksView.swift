import SwiftUI

struct BookmarksView: View {
    @ObservedObject var viewModel: RecipeBookmarkManager
    @State private var showDeleteConfirmation: Bool = false
    @State private var recipeToDelete: Recipe?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.bookmarks.isEmpty {
                    Text("No recipes bookmarked yet.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.bookmarks, id: \.id) { recipe in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(recipe.name)
                                        .font(.headline)
                                    Text(recipe.instructions)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteRecipe)
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.loadBookmarks() // Reload bookmarks every time the view appears
            }
            .toolbar {
                EditButton() // Allows the list to be editable
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Remove Bookmark"),
                    message: Text("Are you sure you want to remove this bookmark?"),
                    primaryButton: .destructive(Text("Remove")) {
                        if let recipe = recipeToDelete {
                            viewModel.removeBookmark(recipe)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    /// Deletes the recipe from the list and updates the storage
    /// - Parameter indexSet: The index of the recipe to delete
    private func deleteRecipe(at indexSet: IndexSet) {
        if let index = indexSet.first {
            recipeToDelete = viewModel.bookmarks[index]
            showDeleteConfirmation = true
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView(viewModel: RecipeBookmarkManager()) // Pass viewModel properly
    }
}
