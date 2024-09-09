//
//  StationCellView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI
import Combine
import ViewLayerInterface

struct StationCellView: View {
    @ObservedObject var state: StationCellState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(state.name)
                .font(.title)
            Text(state.distance )
                .font(.subheadline)
            Text(state.comment)
                .font(.caption)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction {
            state.didSelect()
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
                distance: "100km away",
                comment: "10 bikes / 10 spaces",
                didSelect:  { print("Tap") }
            )
        )
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius))
    }
}
