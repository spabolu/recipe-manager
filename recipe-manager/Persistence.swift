//
//  Persistence.swift
//  recipe-manager
//
//  Created by Saketh Pabolu on 4/20/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Grilled Cheese Recipe
        let grilledCheeseRecipe = Recipe(context: viewContext)
        grilledCheeseRecipe.timestamp = Date()
        grilledCheeseRecipe.id = UUID()
        grilledCheeseRecipe.name = "Grilled Cheese"
        grilledCheeseRecipe.directions =
            "1. Butter one side of each bread slice\n2. Place cheese slice between bread slices\n3. Grill on both sides until cheese is melted"
        grilledCheeseRecipe.ingredients =
            "- 2 slices of bread\n- 1 slice of cheese\n- 1 tbsp of butter"
        grilledCheeseRecipe.servings = 1

        // Oatmeal Recipe
        let oatmealRecipe = Recipe(context: viewContext)
        oatmealRecipe.timestamp = Date()
        oatmealRecipe.id = UUID()
        oatmealRecipe.name = "Oatmeal"
        oatmealRecipe.directions =
            "1. Boil water in a pot\n2. Add oats, cinnamon and salt\n3. Cook for 5-7 minutes until the oatmeal thickens"
        oatmealRecipe.ingredients =
            "- 1/2 cup rolled oats\n- 1 cup water\n- 1/4 tsp cinnamon\n- Pinch of salt"
        oatmealRecipe.servings = 1

        // Smoothie Recipe
        let smoothieRecipe = Recipe(context: viewContext)
        smoothieRecipe.timestamp = Date()
        smoothieRecipe.id = UUID()
        smoothieRecipe.name = "Green Smoothie"
        smoothieRecipe.directions =
            "1. Add kale, banana, mango, and orange juice to a blender\n2. Blend until smooth\n3. Serve chilled"
        smoothieRecipe.ingredients =
            "- 2 cups kale leaves\n- 1 banana\n- 1 cup frozen mango chunks\n- 1 cup orange juice"
        smoothieRecipe.servings = 2

        // Salad Recipe
        let saladRecipe = Recipe(context: viewContext)
        saladRecipe.timestamp = Date()
        saladRecipe.id = UUID()
        saladRecipe.name = "Greek Salad"
        saladRecipe.directions =
            "1. In a large bowl, combine lettuce, cucumber, tomato, onion, and olives\n2. In a small bowl, whisk together olive oil, lemon juice, oregano, salt, and pepper\n3. Drizzle dressing over salad and toss to combine"
        saladRecipe.ingredients =
            "- 2 cups lettuce\n- 1/2 cup chopped cucumber\n- 1/2 cup chopped tomato\n- 1/4 cup chopped red onion\n- 1/4 cup kalamata olives\n- 2 tbsp olive oil\n- 1 tbsp lemon juice\n- 1/2 tsp dried oregano\n- Pinch of salt and pepper"
        saladRecipe.servings = 2

        // Pasta Recipe
        let pastaRecipe = Recipe(context: viewContext)
        pastaRecipe.timestamp = Date()
        pastaRecipe.id = UUID()
        pastaRecipe.name = "Spaghetti Carbonara"
        pastaRecipe.directions =
            "1. Cook spaghetti according to package instructions\n2. Cook bacon until crispy and chop\n3. Whisk eggs and Parmesan cheese together\n4. Drain pasta and add to a pan with bacon\n5. Add egg mixture and stir until creamy\n6. Serve and enjoy!"
        pastaRecipe.ingredients =
            "- 8 oz spaghetti\n- 4 slices bacon\n- 2 eggs\n- 1/2 cup grated Parmesan cheese"
        pastaRecipe.servings = 2

        // Chocolate Pancake Recipe
        let chocolatePancakeRecipe = Recipe(context: viewContext)
        chocolatePancakeRecipe.timestamp = Date()
        chocolatePancakeRecipe.id = UUID()
        chocolatePancakeRecipe.name = "Chocolate Pancakes"
        chocolatePancakeRecipe.directions =
            "1. Whisk together flour, sugar, cocoa powder, baking powder, and salt in a bowl. \n2. In a separate bowl, whisk together milk, egg, and vanilla extract. \n3. Add the wet ingredients to the dry ingredients and mix until just combined. \n4. Heat a nonstick pan over medium heat and add butter. \n5. Pour 1/4 cup batter onto the pan and cook until bubbles form on the surface. \n6. Flip the pancake and cook until lightly browned. \n7. Repeat with remaining batter."
        chocolatePancakeRecipe.ingredients =
            "- 1 cup all-purpose flour\n- 1/4 cup granulated sugar\n- 1/4 cup unsweetened cocoa powder\n- 1 teaspoon baking powder\n- 1/4 teaspoon salt\n- 1 cup milk\n- 1 large egg\n- 1 teaspoon vanilla extract\n- 2 tablespoons unsalted butter, melted and cooled"
        chocolatePancakeRecipe.servings = 2

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "recipe_manager")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
