//
//  BikePointApp.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

@main
struct BikePointApp: App {
    
    let coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.prepareStationsNavigationView()
                .ignoresSafeArea()
        }
    }
}
