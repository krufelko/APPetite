//
//  RecipeBookMarkManager.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

//
//  Recipe.swift
//  Appetite
//
//  Created by Evelyn Tran on 11/16/24.
//

import Foundation
import SwiftUI

class RecipeBookmarkManager: ObservableObject {
    private let bookmarksKey = "bookmarkedRecipes"
    private var bookmarks: [Recipe] = []

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

    func getAllBookmarks() -> [Recipe] {
        return bookmarks
    }
}
