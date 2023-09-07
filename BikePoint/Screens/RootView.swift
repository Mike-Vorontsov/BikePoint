//
//  RootView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

struct RootView: View {
    init(state: StationListsState) {
        self.state = state
    }
    
    let state: StationListsState
    
    var body: some View {
        StationListsView(state: state)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(state: StationListsState(stations: []))
    }
}
