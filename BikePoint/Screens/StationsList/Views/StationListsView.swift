//
//  SationListsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

struct StationListsView: View {
    @ObservedObject var state: StationListsState
    var body: some View {
        //        List(state.stations) { cellState in
        //            StationCellView(state: cellState)
        //        }
        ScrollView(.horizontal) {
            // 2
//            LazyHStack(.top, state.stations) { cellState in
            LazyHStack {
                ForEach(state.stations){ cellState in
                    StationCellView(state: cellState)
                }
            }
        }
//        .frame(height: 100)
        
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
