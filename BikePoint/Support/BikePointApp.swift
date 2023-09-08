//
//  BikePointApp.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

@main
struct BikePointApp: App {
    
    let persistenceController = PersistenceController.shared

   
    let coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.prepareStationsNavigationView()
//            ContentView()
//            RootView(coordinator: coordinator)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
