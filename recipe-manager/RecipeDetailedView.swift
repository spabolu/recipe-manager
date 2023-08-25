//
//  RecipeDetailedView.swift
//  recipemanager
//
//  Created by Saketh Pabolu on 4/7/23.
//

import CoreData
import Foundation
import SwiftUI

struct RecipeDetailedView: View {
    let recipe: Recipe

    @State private var responseJSON: String = ""

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    func sendPOSTRequest() {
        let url = URL(
            string:
                "https://api.edamam.com/api/nutrition-details?app_id=47379841&app_key=d28718060b8adfd39783ead254df7f92"
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let ingredientStrings = recipe.ingredients!.components(separatedBy: "\n")

        let trimmedIngredientStrings = ingredientStrings.map {
            $0.trimmingCharacters(in: .whitespaces)
        }

        let parameters = ["ingr": trimmedIngredientStrings]

        print("List of Ingredients: \(parameters)")

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }

            if let data = data {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                //                print("Response: \(responseJSON ?? "Unkown")")

                if let json = responseJSON as? [String: Any],
                    let calories = json["calories"] as? Int
                {
                    self.responseJSON = "Calories: \(calories)"
                }
            }

        }

        task.resume()

    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Ingredients:")
                    .font(.title)
                    .bold()

                let fractions: [String: String] = [
                    "1/4": "\u{00BC}",
                    "1/2": "\u{00BD}",
                    "3/4": "\u{00BE}",
                    "1/3": "\u{2153}",
                    "2/3": "\u{2154}",
                    "1/5": "\u{2155}",
                ]

                let ingredientsWithFractions = fractions.reduce(
                    into: recipe.ingredients ?? "Unknown"
                ) { result, fraction in
                    result = result.replacingOccurrences(of: fraction.key, with: fraction.value)
                }

                Text(ingredientsWithFractions)
                    .font(.body)

                Text("Servings: ")
                    .font(.headline)
                    + Text("\(recipe.servings)")
                    .font(.body)

                Text(responseJSON)

                Divider()

                Text("Directions:")
                    .font(.title)
                    .bold()

                let directionsWithFractions = fractions.reduce(
                    into: recipe.directions ?? "Unknown"
                ) { result, fraction in
                    result = result.replacingOccurrences(of: fraction.key, with: fraction.value)
                }

                Text(directionsWithFractions)
                    .font(.body)

                Text(
                    "Recipe Added On \(recipe.timestamp.map(Self.dateFormatter.string(from:)) ?? "Unknown Date")"
                )
                .padding(.top, 24)
                .font(.caption)
                .italic()

                Spacer()
            }
            .onAppear {
                sendPOSTRequest()
            }
            .padding()
            .navigationTitle(recipe.name ?? "Unknown")
            //            .toolbar {
            //                Button(action: {
            //                    print("Edit Recipe Tapped!")
            //                }) {
            //                    Label("Edit Recipe", systemImage: "pencil")
            //                        .foregroundColor(Color.blue)
            //                }
            //            }
        }

    }
}

struct RecipeDetailedView_Previews: PreviewProvider {
    static var previews: some View {

        // Chocolate Pancake Recipe
        let chocolatePancakeRecipe = Recipe(
            context: PersistenceController.preview.container.viewContext)
        chocolatePancakeRecipe.timestamp = Date()
        chocolatePancakeRecipe.id = UUID()
        chocolatePancakeRecipe.name = "Chocolate Pancakes"
        chocolatePancakeRecipe.directions =
            "1. Whisk together flour, sugar, cocoa powder, baking powder, and salt in a bowl. \n2. In a separate bowl, whisk together milk, egg, and vanilla extract. \n3. Add the wet ingredients to the dry ingredients and mix until just combined. \n4. Heat a nonstick pan over medium heat and add butter. \n5. Pour 1/4 cup batter onto the pan and cook until bubbles form on the surface. \n6. Flip the pancake and cook until lightly browned. \n7. Repeat with remaining batter."
        chocolatePancakeRecipe.ingredients =
            "- 1 cup all-purpose flour\n- 1/4 cup granulated sugar\n- 1/4 cup unsweetened cocoa powder\n- 1 teaspoon baking powder\n- 1/4 teaspoon salt\n- 1 cup milk\n- 1 large egg\n- 1 teaspoon vanilla extract\n- 2 tablespoons unsalted butter, melted and cooled"
        chocolatePancakeRecipe.servings = 2

        return RecipeDetailedView(recipe: chocolatePancakeRecipe)
    }
}
