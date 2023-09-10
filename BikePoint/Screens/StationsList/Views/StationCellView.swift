//
//  StationCellView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI
import Combine

struct StationCellView: View {
    @ObservedObject var state: StationCellState
    
    var body: some View {
        VStack {
            Text(state.name)
            Text(state.distance)
        }
        .padding(Metrics.cellPadding)
        .onTapGesture {
            state.didSelect()
        }
    }
}

struct StationCellView_Previews: PreviewProvider {
    static var previews: some View {
        StationCellView(
            state: .init(
                name: "Hello",
                distance: "World!",
                didSelect:  { print("Tap") }
            )
        )
    }
}
