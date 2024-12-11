//
//  RecipePanelView.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import SwiftUI

struct RecipePanel: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack {
            // Background image
            AsyncImage(url: URL(string: recipe.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } placeholder: {
                // Placeholder while image loads
                Color.gray.opacity(0.3)
            }
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("easy") // Example difficulty, can be dynamic
                        .font(.caption)
                        .foregroundColor(.white)
                    Spacer()
                    Text("15 min") // Example time, can be dynamic
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
            }
            .padding(10)
        }
        .frame(height: 150) // Adjust height as needed
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct RecipePanel_Previews: PreviewProvider {
    static var previews: some View {
        RecipePanel(recipe: Recipe(
            id: "1",
            name: "Scrambled Eggs",
            instructions: "Beat eggs. Cook in a pan. Season and serve.",
            ingredients: ["Eggs", "Salt", "Butter"],
            measures: ["2", "1 tsp", "1 tbsp"],
            imageURL: "https://www.themealdb.com/images/media/meals/58oia61564916529.jpg"
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
