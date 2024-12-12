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
                    Image(systemName: "frying.pan")
                    Text("Home")
                }
            
            ShoppingListView()
                .tabItem {
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("Shopping List")
                }
            
            BookmarksView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Bookmarks")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "wrench.adjustable")
                    Text("Settings")
                }
        }
    }
}


