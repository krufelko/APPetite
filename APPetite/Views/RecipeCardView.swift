//
//  RecipeCard.swift
//  Appetite
//
//  Created by Evelyn Tran on 11/16/24.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Recipe Image
            AsyncImage(url: URL(string: recipe.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image(systemName: "photo")
                        .font(.largeTitle)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)
            .clipped()
            .cornerRadius(12)
            
            // Recipe Details
            VStack(alignment: .leading, spacing: 12) {
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Ingredients Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                    
                    ForEach(Array(zip(recipe.ingredients, recipe.measures)), id: \.0) { ingredient, measure in
                        Text("• \(measure) \(ingredient)")
                            .font(.subheadline)
                    }
                }
                
                Divider()
                
                // Steps Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Steps")
                        .font(.headline)
                    
                    ForEach(recipe.simplifiedSteps.indices, id: \.self) { index in
                        Text("\(index + 1). \(recipe.simplifiedSteps[index])")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
