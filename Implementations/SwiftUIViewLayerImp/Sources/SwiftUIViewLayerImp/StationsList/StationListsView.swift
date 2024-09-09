//
//  SationListsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI
import ViewLayerInterface

public struct StationListsView: View {
    public init(state: StationsListState) {
        self.state = state
    }
        
    @ObservedObject var state: StationsListState
    
    @Environment(ThemeProvider.self) private var themeProvider: ThemeProvider
      
    public var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(state.stations){ cellState in
                        StationCellView(
                            state: cellState
                        )
                        .background(
                            state.selectedCell?.name == cellState.name ?
                            themeProvider.currentTheme.focus : themeProvider.currentTheme.available
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius))
                        .id(cellState.name)
                    }
                    .animation(.default, value: state.stations)
                }
            }
            .onReceive(state.$selectedCell) { newSelectedIndex in
                withAnimation {
                    value.scrollTo(newSelectedIndex?.name, anchor: .bottom)
                }
            }
        }
        .accessibilityLabel("Bike stations in vicinity")
        
    }
}

struct StationListsView_Previews: PreviewProvider {
    static var previews: some View {
        StationListsView(
            state: .init(
                stations: [
                    .init(name: "Times Square", distance: "Very fare away", comment: "10 bikes\n 12 spaces"),
                    .init(name: "Hanwell", distance: "12 km away", comment: "10 bikes 12 spaces"),
                ]
            )
        )
        .environment(ThemeProvider(currentTheme: .init(available: .green, focus: .blue)))
    }
}
