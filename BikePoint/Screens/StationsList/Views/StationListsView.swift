//
//  SationListsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

struct StationListsView: View {
    @ObservedObject var state: StationsListState
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(state.stations){ cellState in
                        StationCellView(
                            state: cellState
                        )
                        .background(state.selectedCell?.name == cellState.name ? .green : .blue)
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
    }
}
