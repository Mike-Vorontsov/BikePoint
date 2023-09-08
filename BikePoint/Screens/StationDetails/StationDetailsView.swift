//
//  StationDetailsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import SwiftUI
import Combine


struct StationDetailsView: View {
    @ObservedObject var state: StationDetailsState
    var body: some View {
        Text(state.name)
    }
}

struct StationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StationDetailsView(
            state: .init(
                name: "Hello",
                distance: "100m",
                address: "11 myrtle gardens"
            )
        )
    }
}
