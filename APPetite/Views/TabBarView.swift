//
//  TabBar.swift
//  APPetite
//
//  Created by Felix Krumme on 10.12.24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ShoppingListView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Shopping List")
                }
            
            BookmarksView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Bookmarks")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

// Placeholder views for each tab

struct ShoppingListView: View {
    var body: some View {
        Text("Shopping List")
    }
}

struct BookmarksView: View {
    var body: some View {
        Text("Bookmarks")
    }
}

struct SearchView: View {
    var body: some View {
        Text("Search")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}
