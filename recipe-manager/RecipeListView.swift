//
//  RecipeListView.swift
//  recipe-manager
//
//  Created by Saketh Pabolu on 4/2/23.
//

import CoreData
import Foundation
import SwiftUI

struct RecipeListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: false)])
    var recipes: FetchedResults<Recipe>

    @Environment(\.managedObjectContext) private var viewContext

    @State private var addRecipeView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailedView(recipe: recipe)) {
                        Text(recipe.name ?? "Unknown")
                    }
                }
                .onDelete(perform: deleteRecipes)
            }
            .listStyle(.automatic)

            .navigationTitle("All Recipes")
            .toolbar {
                Button(action: {
                    print("Add Recipe Tapped!")
                    addRecipeView = true
                }) {
                    Label("Add Recipe", systemImage: "plus")
                        .foregroundColor(Color.blue)
                }
            }
            .popover(
                isPresented: $addRecipeView,
                content: {
                    AddRecipe()
                        .onDisappear {
                            addRecipeView = false
                        }
                }
            )

            NavigationLink(
                destination:
                    ShoppingList()
                    .navigationTitle("Shopping List")
                    .navigationBarTitleDisplayMode(.inline)
            ) {
                Label("Shopping List", systemImage: "cart.fill")
                    .foregroundColor(Color.blue)
                    .padding(.vertical, 4)
            }
        }

    }

    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            offsets.map { recipes[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }

}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView().environment(
            \.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
