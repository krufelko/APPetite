//
//  BookmarkView.swift
//  Appetite
//
//  Created by Felix Krumme on 11/12/24.
//

import SwiftUI

struct BookmarkView: View {
    @StateObject private var bookmarkManager = RecipeBookmarkManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(bookmarkManager.getAllBookmarks().sorted(by: { $0.name < $1.name })) { recipe in
                    NavigationLink(destination: RecipeCardView(recipe: recipe)) {
                        Text(recipe.name)
                            .font(.headline)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Bookmarked Recipes")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        let sortedBookmarks = bookmarkManager.getAllBookmarks().sorted(by: { $0.name < $1.name })
        offsets.forEach { index in
            let recipeToDelete = sortedBookmarks[index]
            bookmarkManager.removeBookmark(recipeToDelete)
        }
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}

