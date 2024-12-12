import Foundation
import Combine

class RecipeBookmarkManager: ObservableObject {
    @Published private(set) var bookmarks: [Recipe] = []
    private let bookmarksKey = "bookmarkedRecipes"
    
    init() {
        loadBookmarks()
    }
    
    func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey) {
            do {
                let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
                bookmarks = decodedRecipes
            } catch {
                print("Failed to decode bookmarks: \(error)")
            }
        }
    }
    
    func saveBookmarks() {
        do {
            let data = try JSONEncoder().encode(bookmarks)
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        } catch {
            print("Failed to save bookmarks: \(error)")
        }
    }
    
    func addBookmark(_ recipe: Recipe) {
        if !bookmarks.contains(where: { $0.id == recipe.id }) {
            bookmarks.append(recipe)
            saveBookmarks()
        }
    }
    
    func removeBookmark(_ recipe: Recipe) {
        bookmarks.removeAll(where: { $0.id == recipe.id })
        saveBookmarks()
    }
    
    func isBookmarked(_ recipe: Recipe) -> Bool {
        return bookmarks.contains(where: { $0.id == recipe.id })
    }
}
