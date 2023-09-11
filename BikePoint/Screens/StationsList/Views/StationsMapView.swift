//
//  StationsMapView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import SwiftUI
import MapKit
import Combine

struct StationsMapView<Content: View>: View {
    @StateObject var state: StationsMapState
    @State var cameraPosition: MapCameraPosition = .userLocation(
        followsHeading: true,
        fallback: .automatic
    )
    
    let content: (() -> Content)?
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(state.markers) { markerState in
                Annotation(markerState.title, coordinate: markerState.coordinates, anchor: .bottom) {
                    ZStack{
                        RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                            .fill(.background)

                        RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                            .stroke(state.selectedMarker?.title == markerState.title ? .green : .blue, lineWidth: 5.0)
                            
                        Image(systemName: "bicycle")
                            .padding(Metrics.cellPadding)
                    }
                    .onTapGesture {
                        markerState.didSelect?()
                    }
                }
            }
            UserAnnotation()
        }
        .safeAreaInset(edge: .bottom) {
            content?()
                .frame(height: Metrics.cellHeight)
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .onReceive(state.$selectedMarker) { selectedMarker  in
            guard let selectedMarker else { return }
            withAnimation{
                cameraPosition = .camera(
                    MapCamera(
                        centerCoordinate: selectedMarker.coordinates,
                        distance: MapMetrics.defaultCameraDistance
                    )
                )
            }
        }
    }
}

struct StationsMapView_Previews: PreviewProvider {
    static var previews: some View {
        StationsMapView(
            state: StationsMapState(
                markers: [
                    .init(
                        coordinates: londonCenter,
                        title: "London"
                    ),
                    .init(
                        coordinates: greenwich,
                        title: "Greenwich"
                    ),

                ]
            ),
            content: {
                Text("Hello world!")
                    .padding(10)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
            }
        )
    }
    
    static let londonCenter  = CLLocationCoordinate2D(
        latitude: 51.509865,
        longitude: -0.118092
    )
    
    static let greenwich = CLLocationCoordinate2D(
        latitude: 51.477928,
        longitude: -0.001545
    )

}

