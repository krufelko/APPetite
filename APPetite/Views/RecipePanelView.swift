import SwiftUI

struct RecipePanel: View {
    let recipe: Recipe
    private let panelWidth: CGFloat = 200 // Fixed width for all panels
    
    var body: some View {
        NavigationLink(destination: RecipeCardView(recipe: recipe)) {
            ZStack {
                // Background image
                AsyncImage(url: URL(string: recipe.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: panelWidth, height: 150) // Match fixed width and height
                        .clipped() // Clip to panel size
                } placeholder: {
                    // Placeholder while image loads
                    Color.gray.opacity(1)
                        .frame(width: panelWidth, height: 150) // Match fixed width and height
                        .cornerRadius(10)
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
                        .lineLimit(2) // Allow text to wrap to two lines
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(10)
            }
            .frame(width: panelWidth, height: 150) // Fixed width and height for panel
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

struct RecipePanel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipePanel(recipe: Recipe(
                id: "1",
                name: "Delicious Scrambled Eggs with Cheddar and Chives", // Long title to test wrapping
                instructions: "Beat eggs. Cook in a pan. Season and serve.",
                ingredients: ["Eggs", "Salt", "Butter"],
                measures: ["2", "1 tsp", "1 tbsp"],
                imageURL: "https://www.themealdb.com/images/media/meals/58oia61564916529.jpg"
            ))
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
