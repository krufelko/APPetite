//
//  RecipeInstructionsView.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//

import SwiftUI

struct RecipeInstructionsView: View {
    let instructions: [String]

    var body: some View {
        NavigationView {
            TabView {
                ForEach(0..<instructions.count, id: \ .self) { index in
                    VStack {
                        Text("\(index + 1). Step")
                            .font(.headline)
                            .padding()
                            .background(Color.yellow)
                            .clipShape(Capsule())

                        Spacer()

                        Text(instructions[index])
                            .font(.body)
                            .padding()

                        Spacer()

                        Text("\(index + 1)/\(instructions.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .navigationTitle("Recipe Steps")
        }
    }
}

struct RecipeInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeInstructionsView(instructions: [
            "Crack five eggs into a bowl.",
            "Add 1/2 teaspoon of salt.",
            "Add 1/2 teaspoon of pepper.",
            "Add one tablespoon of water.",
            "Mix with a fork for 30 seconds.",
            "Place the pan on the stove and turn to medium heat.",
            "Add one tablespoon of oil to the pan.",
            "Add the egg mixture to the pan.",
            "Cook on medium heat for two minutes while stirring."
        ])
    }
}
