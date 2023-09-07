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
    @Published var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

struct StationCellView: View {
    @ObservedObject var state: StationCellState
    
    var body: some View {
        VStack {
            Text(state.name)
            Text(state.address)
        }
        .padding(Metrics.cellPadding)
        .background(.gray)
        
    }
}

struct StationCellView_Previews: PreviewProvider {
    static var previews: some View {
        StationCellView(
            state: .init(
                name: "Hello",
                address: "World!"
            )
        )
    }
}