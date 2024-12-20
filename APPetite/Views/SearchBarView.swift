//
//  SearchBar.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//


import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    
    // Define a closure or action for the search
    var onSearch: (String) -> Void = { _ in }
    
    var body: some View {
        VStack {
            HStack {
                // Search TextField
                TextField("Find Recipes...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .overlay(
                        HStack {
                            Spacer()
                            // Dynamic button
                            Button(action: {
                                searchText = "" // Clear search text
                            }) {
                                Image(systemName: searchText.isEmpty ? "magnifyingglass" : "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    )
                    .onSubmit {
                        // Trigger the search action on "Enter"
                        onSearch(searchText)
                    }
                    .onChange(of: searchText) {
                        onSearch(searchText) // Use the updated value directly
                    }
                    .padding(.horizontal, 10)
            }
            .cornerRadius(25)
            .padding()
            
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
        .previewLayout(.sizeThatFits)
    }
}
