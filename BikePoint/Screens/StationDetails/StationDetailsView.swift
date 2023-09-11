//
//  StationDetailsView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import SwiftUI
import Combine
import MapKit

struct StationDetailsView: View {
    @ObservedObject var state: StationDetailsState
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    var details: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(state.distance).font(.callout)
                Text(state.address).font(.caption)
            }
            .frame(maxWidth: .infinity)
//            .padding(Metrics.cellPadding * 2)
//            .background(.gray)
//            .clipShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius))
            
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "bicycle")
                    Text("cycling time: 10m")
                }
                HStack{
                    Image(systemName: "figure.walk.motion")
                    Text("cycling time: 1h 10m")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Metrics.cellPadding * 2)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius))
        }
        .padding(10)

    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: {
                    state.onBack?()
                } ){
                    Image(systemName: "chevron.backward.square")
                }
                Text(state.name).font(.headline)
            }
            .padding(Metrics.cellPadding)
            Divider()

            GeometryReader { geo in
                if geo.size.width > geo.size.height {
                    HStack {
                        details
                            .frame(width: geo.size.width / 1/3)
                        LookAroundPreview(scene: $lookAroundScene)
                            .padding(Metrics.cellPadding)
                    }
                } else {
                    VStack {
                        details
                        LookAroundPreview(scene: $lookAroundScene)
                            .padding(Metrics.cellPadding)
                    }
                }
            }
        }
        .onAppear{
            getLookAroundScene(for: state.coordinates)
        }

    }
    
    private func getLookAroundScene(for coordinates: Coordinate) {
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
                address: "11 myrtle gardens",
                coordinates: londonCenter
            )
        )
    }
    
    private static let londonCenter  = CLLocationCoordinate2D(
        latitude: 51.509865,
        longitude: -0.118092
    )

}
    
  
