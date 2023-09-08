//
//  RootView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import SwiftUI

struct RootView: View {
    init(coordinator: Coordinating) {
        content = coordinator.prepareStationsListView()
    }
    
    let content: StationListsView
    
    var body: some View {
        content
    }
}


struct FakeCoordinator: Coordinating {
    func prepareStationsListView() -> StationListsView {
        return StationListsView(state: StationListsState(stations: []))
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(coordinator: FakeCoordinator())
    }
}
