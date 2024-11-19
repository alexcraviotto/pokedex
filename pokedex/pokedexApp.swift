//
//  pokedexApp.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 5/11/24.
//

import SwiftUI
import CoreData

@main
struct pokedexApp: App {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokedexModel")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                // Imprimir información más detallada sobre el error
                print("Error al cargar Core Data: \(error), \(error.userInfo)")
                fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
            } else {
                print("Store cargado exitosamente: \(description)")
            }
        }
        return container
    }()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
