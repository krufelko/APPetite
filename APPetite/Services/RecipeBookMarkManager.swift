import Foundation
import Combine

class RecipeBookmarkManager: ObservableObject {
    @Published private(set) var bookmarks: [Recipe] = []
    private let bookmarksKey = "bookmarkedRecipes"
    
    init() {
        loadBookmarks()
    }
    
    /// Loads bookmarks from UserDefaults
    func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey) {
            do {
                let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
                bookmarks = decodedRecipes
            } catch {
                print("Failed to decode bookmarks: \(error.localizedDescription)")
            }
        }
    }
    
    /// Saves the current bookmarks to UserDefaults
    func saveBookmarks() {
        do {
            let data = try JSONEncoder().encode(bookmarks)
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        } catch {
            print("Failed to save bookmarks: \(error.localizedDescription)")
        }
    }
    
    /// Adds a new bookmark if it does not already exist
    /// - Parameter recipe: The recipe to add to the bookmarks
    func addBookmark(_ recipe: Recipe) {
        if !bookmarks.contains(where: { $0.id == recipe.id }) {
            bookmarks.append(recipe)
            saveBookmarks()
        }
    }
    
    /// Removes a bookmark if it exists
    /// - Parameter recipe: The recipe to remove from the bookmarks
    func removeBookmark(_ recipe: Recipe) {
        bookmarks.removeAll(where: { $0.id == recipe.id })
        saveBookmarks()
    }
    
    /// Checks if a recipe is bookmarked
    /// - Parameter recipe: The recipe to check
    /// - Returns: `true` if the recipe is bookmarked, otherwise `false`
    func isBookmarked(_ recipe: Recipe) -> Bool {
        return bookmarks.contains(where: { $0.id == recipe.id })
    }
}
