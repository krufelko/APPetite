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
            
            BookmarkView()
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

