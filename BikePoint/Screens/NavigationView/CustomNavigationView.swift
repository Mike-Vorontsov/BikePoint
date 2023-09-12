//
//  NavigationView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import UIKit
import SwiftUI

/// Convenience protocol for basic navigation
protocol Navigating {
    func push(view: some View)
    func pop()
}

/// Extension to make NavigationController to operate with SwiftUI views
extension UINavigationController: Navigating {
    func push(view: some View) {
        let hostingVC = UIHostingController(rootView: view)
        pushViewController(hostingVC, animated: true)
    }
    
    func pop() {
        popViewController(animated: true)
    }
}

/// Swift UI wrapper around  navigation controller
struct CustomNavigationView: UIViewRepresentable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // Public interface for NavigationController
    var navigator: Navigating { navigationController as Navigating }
    
    func makeUIView(context: Context) -> UIView {
        navigationController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
