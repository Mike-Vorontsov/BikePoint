//
//  NavigationView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import UIKit
import SwiftUI

import ViewLayerInterface

/// Swift UI wrapper around  navigation controller
struct CustomNavigationView: UIViewRepresentable, Navigating {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // interface for NavigationController
    var navigator: Navigating { navigationController as Navigating }
    
    func makeUIView(context: Context) -> UIView {
        navigationController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func push(view: some Navigatable) {
        navigationController.push(view: view)
    }
    
    func pop() {
        navigationController.pop()
    }

}
