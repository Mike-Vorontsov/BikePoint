//
//  Theme.swift
//  
//
//  Created by Mykhailo Vorontsov on 09/09/2024.
//

import SwiftUI

public struct Theme {
    public init(available: Color, focus: Color) {
        self.available = available
        self.focus = focus
    }
    
    public let available: Color
    public let focus: Color
}

final public class ThemeProvider: Observable {
    public init(currentTheme: Theme) {
        self.currentTheme = currentTheme
    }
    
    var currentTheme: Theme
}
