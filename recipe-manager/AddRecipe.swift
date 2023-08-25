//
//  AddRecipe.swift
//  recipe-manager
//
//  Created by Saketh Pabolu on 4/20/23.
//

import Foundation
import SwiftUI

struct AddRecipe: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Recipe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)])
    private var recipes: FetchedResults<Recipe>

    @State private var newRecipeName = ""
    @State private var newRecipeServings = ""
    @State private var newRecipeDirections = "1. \n2. \n3. "
    @State private var newRecipeIngredients = "- \n- \n- \n- \n"

    var body: some View {
        NavigationView {
            Form {
                TextField("Recipe Name", text: $newRecipeName)
                TextField("Servings", text: $newRecipeServings)
                    .keyboardType(.numberPad)

                Section(header: Text("Ingredients")) {
                    TextEditor(text: $newRecipeIngredients)
                        .frame(minHeight: 100)
                }

                Section(header: Text("Directions")) {
                    TextEditor(text: $newRecipeDirections)
                        .frame(minHeight: 100)
                }

                Section {
                    Button(action: {
                        let newRecipe = Recipe(context: viewContext)
                        newRecipe.timestamp = Date()
                        newRecipe.id = UUID()
                        newRecipe.name = newRecipeName
                        newRecipe.servings = Int16(newRecipeServings) ?? 0
                        newRecipe.directions = newRecipeDirections
                        newRecipe.ingredients = newRecipeIngredients

                        do {
                            try viewContext.save()
                            print("Recipe \(newRecipeName) Saved!")
                        } catch {
                            let error = error as NSError
                            fatalError("Unresolved error: \(error)")
                        }

                        newRecipeName = ""
                        newRecipeServings = ""
                        newRecipeDirections = ""
                        newRecipeIngredients = ""
                    }) {
                        Text("Save Recipe")
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .listRowBackground(Color.clear)

                .navigationTitle("Add Recipe")
            }
        }
    }
}

struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipe()
    }
}
