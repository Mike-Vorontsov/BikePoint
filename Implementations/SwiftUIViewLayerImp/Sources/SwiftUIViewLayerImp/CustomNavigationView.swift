//
//  NavigationView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import UIKit
import SwiftUI
import ViewLayerInterface

/// Extension to make NavigationController to operate with SwiftUI views
extension UINavigationController: @retroactive Navigating {
    public func push(view: some Navigatable) {
        
        guard let view = view as? AnyView else { return }
        
        let hostingVC = UIHostingController(rootView: view)
        pushViewController(hostingVC, animated: true)
    }
    
    public func pop() {
        popViewController(animated: true)
    }
}

extension AnyView: @retroactive Navigatable {}

/// Swift UI wrapper around  navigation controller
public struct CustomNavigationView: UIViewRepresentable {
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // Public interface for NavigationController
    var navigator: Navigating { navigationController as Navigating }
    
    public func makeUIView(context: Context) -> UIView {
        navigationController.view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}
