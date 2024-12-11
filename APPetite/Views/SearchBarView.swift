//
//  SearchBarView.swift
//  APPetite
//
//  Created by Felix Krumme on 10.12.24.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    
    var body: some View {
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
                .padding(.horizontal, 10)
        }
        .cornerRadius(25)
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .previewLayout(.sizeThatFits)
    }
}
