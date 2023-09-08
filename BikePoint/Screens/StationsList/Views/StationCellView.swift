//
//  StationCellView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI
import Combine

final class StationCellState: ObservableObject, Identifiable {
    @Published var name: String
    @Published var distance: String
    typealias DidSelect = (() -> ())
    var didSelect: DidSelect
    
    init(name: String, distance: String, didSelect:  @escaping DidSelect = {} ) {
        self.name = name
        self.distance = distance
        self.didSelect = didSelect
    }
}

struct StationCellView: View {
    @ObservedObject var state: StationCellState
    
    var body: some View {
        VStack {
            Text(state.name)
            Text(state.distance)
        }
        .padding(Metrics.cellPadding)
        .background(.gray)
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
