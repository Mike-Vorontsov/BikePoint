//
//  SationListsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

final class StationListsState: ObservableObject {
    @Published var stations: [StationCellState]
    
    init(stations: [StationCellState]) {
        self.stations = stations
    }
}

struct StationListsView: View {
    @ObservedObject var state: StationListsState
    var body: some View {
        List(state.stations) {
            StationCellView(state: $0)
        }
    }
}

struct StationListsView_Previews: PreviewProvider {
    static var previews: some View {
        StationListsView(
            state: .init(
                stations: [
                    .init(name: "Hello", distance: "World!"),
                    .init(name: "Hanwell", distance: "11 Myrtle Gardens"),
                    .init(name: "Padington", distance: "211 Sussex Gardens"
                         ),
                    .init(name: "Earls court", distance: "75 Longridge Road")
                ]
            )
        )
    }
}
