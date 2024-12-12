import SwiftUI

struct BookmarksView: View {
    @StateObject private var viewModel = RecipeBookmarkManager()
    
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
                        ForEach(viewModel.bookmarks, id: \ .id) { recipe in
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
        }
    }
    
    /// Deletes the recipe from the list and updates the storage
    /// - Parameter indexSet: The index of the recipe to delete
    private func deleteRecipe(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let recipe = viewModel.bookmarks[index]
            viewModel.removeBookmark(recipe)
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
