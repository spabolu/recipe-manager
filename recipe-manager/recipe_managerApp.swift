//
//  recipe_managerApp.swift
//  recipe-manager
//
//  Created by Saketh Pabolu on 4/20/23.
//

import SwiftUI

@main
struct recipe_managerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
