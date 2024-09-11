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
