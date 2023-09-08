//
//  NavigationView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import UIKit
import SwiftUI

protocol Navigating {
    func push(view: some View)
    func pop()
}

extension UINavigationController: Navigating {
    func push(view: some View) {
        let hostingVC = UIHostingController(rootView: view)
        pushViewController(hostingVC, animated: true)
    }
    
    func pop() {
        popViewController(animated: true)
    }
}

struct CustomNavigationView: UIViewRepresentable, Navigating {
    private let navigationController: UINavigationController
    var navigator: Navigating { navigationController as Navigating }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init(content: some View) {
        let hostingVC = UIHostingController(rootView: content)
        navigationController = UINavigationController(rootViewController: hostingVC)
    }

    func makeUIView(context: Context) -> UIView {
        navigationController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func push(view: some View) {
        navigationController.push(view: view)
    }
    
    func pop() {
        navigationController.pop()
    }
    
}
