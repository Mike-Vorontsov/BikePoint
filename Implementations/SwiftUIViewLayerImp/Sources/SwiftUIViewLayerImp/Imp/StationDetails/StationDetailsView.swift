//
//  StationDetailsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import SwiftUI
import Combine
import MapKit

import Common
import ViewLayerInterface

struct StationDetailsView: View {
    init(state: StationDetailsState) {
        self.state = state
    }
    
    @ObservedObject var state: StationDetailsState
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    var details: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(state.address)
                    .font(.caption)
                    .accessibilitySortPriority(1)
                    .accessibilityLabel("Address: \(state.address)")
                Text(state.distance)
                    .font(.callout)
                    .accessibilitySortPriority(2)
                    .accessibilityLabel("Distance: \(state.distance)")
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(Metrics.margins)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(
                    action: {
                        state.onBack?()
                }){
                    Image(systemName: "chevron.backward")
                }
                .accessibilitySortPriority(0)
                Text(state.name)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilitySortPriority(5)
                    .accessibilityLabel("selected station: \(state.name)")
            }
            .padding(Metrics.cellPadding)
            Divider()

            GeometryReader { geo in
                if geo.size.width > geo.size.height {
                    HStack {
                        details
                            .frame(width: geo.size.width / 1/3)
                        LookAroundPreview(scene: $lookAroundScene)
                            .padding(Metrics.margins)
                    }
                } else {
                    VStack {
                        details
                        LookAroundPreview(scene: $lookAroundScene)
                            .padding(Metrics.margins)
                    }
                }
            }
        }
        .onAppear{
            getLookAroundScene(for: state.coordinates)
        }

    }
    
    private func getLookAroundScene(for coordinates: Coordinates) {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(coordinate: coordinates)
            lookAroundScene = try? await request.scene
        }
    }
    
    
}

struct StationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StationDetailsView(
            state: .init(
                name: "Title: central london",
                distance: "100m",
                address: "49 Orange St London England WC2H 7HS United Kingdom",
                coordinates: londonCenter
            )
        )
    }
    
    private static let londonCenter  = CLLocationCoordinate2D(
        latitude: 51.509865,
        longitude: -0.118092
    )

}
    
  
