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

    let presenter: StationsListPresenter = .init(
        service: NetworkService(
            config: .init(
                baseUrl: URL(string: "https://api.tfl.gov.uk")!,
                headers: [:]
            )
        ),
        mapper: StationsListStateMapper()
    )
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            RootView(state: presenter.state)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
