//
//  ShoppingListView.swift
//  APPetite
//
//  Created by Felix Krumme on 11.12.24.
//
import SwiftUI

struct ShoppingListView: View {
    @State private var items: [String] = ["Eggs", "Milk", "Bread", "Butter", "Cheese", "Flour", "Sugar", "Salt"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(items, id: \.self) { item in
                        ShoppingListItemView(item: item, onDelete: {
                            if let index = items.firstIndex(of: item) {
                                items.remove(at: index)
                            }
                        }, onBought: {
                            print("\(item) bought!")
                        })
                    }
                }
            }
            .navigationTitle("Shopping List")
        }
    }
}

struct ShoppingListItemView: View {
    let item: String
    let onDelete: () -> Void
    let onBought: () -> Void
    
    var body: some View {
        SwipeActionsListView(
            content: {
                HStack {
                    Text(item)
                        .font(.title2)
                        .padding()
                    Spacer()
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
            },
            actions: [
                .init(title: "More", backgroundColor: .gray, action: {
                    print("More options for \(item)")
                }),
                .init(title: "Bought", backgroundColor: .green, action: {
                    onBought()
                }),
                .init(title: "Delete", backgroundColor: .red, action: {
                    onDelete()
                })
            ]
        )
        .padding(.horizontal)
    }
}

struct SwipeActionsListView<Content: View>: View {
    let content: Content
    let actions: [SwipeAction]
    
    init(content: @escaping () -> Content, actions: [SwipeAction]) {
        self.content = content()
        self.actions = actions
    }
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(actions, id: \.title) { action in
                    Button(action: action.action) {
                        Text(action.title)
                            .foregroundColor(.white)
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(action.backgroundColor)
                            .cornerRadius(10)
                    }
                }
            }
            content
                .padding(.trailing, CGFloat(actions.count * 60)) // Adjust trailing padding based on action count
        }
    }
}

struct SwipeAction {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
