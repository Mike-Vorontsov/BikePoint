//
//  BikePointApp.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI
import SwiftUIViewLayerImp

@main
struct BikePointApp: App {
    
    let coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator
                .prepareRootView()
                .ignoresSafeArea()
                .environment(
                    ThemeProvider(
                        currentTheme: .init(available: .available, focus: .focus)
                    )
                )
        }
    }
}
