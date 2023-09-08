//
//  StationsMapView.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import SwiftUI
import MapKit
import Combine

final class StationMarketState: Identifiable {
    internal init(coordinates: Coordinate, title: String, didSelect:  DidSelect? = nil) {
        self.didSelect = didSelect
        self.coordinates = coordinates
        self.title = title
    }
    
    
    @Published var coordinates: Coordinate
    @Published var title: String
    @Published var region: MKCoordinateRegion = .london

    typealias DidSelect = (() -> ())
    var didSelect: DidSelect?
}

final class StationsMapState: ObservableObject {
    
    internal init(markers: [StationMarketState]) {
        self.markers = markers
    }
    
    @Published var markers: [StationMarketState]
}

struct StationsMapView<Content: View>: View {
    @StateObject var state: StationsMapState
    let content: (() -> Content)?
    
    var body: some View {
        Map {
            ForEach(state.markers) { markerState in
//                Marker($0.title, coordinate: $0.coordinates)
                Annotation(markerState.title, coordinate: markerState.coordinates, anchor: .bottom) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.background)
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 5.0)
                        Image(systemName: "bicycle")
                            .padding(5)
                    }
                    .onTapGesture {
                        markerState.didSelect?()
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            content?()
                .frame(height: 100)
        }
        
        
    }
}

struct StationsMapView_Previews: PreviewProvider {
    static var previews: some View {
        StationsMapView(
            state: StationsMapState(
                markers: [
                    .init(
                        coordinates: CLLocationCoordinate2D.cityHallLocation,
                        title: "London"
                    )
                ]
            ),
            content: { EmptyView() }
        )
        
    }
}

extension CLLocationCoordinate2D {
    static var cityHallLocation  = CLLocationCoordinate2D(
        latitude: 51.509865,
        longitude: -0.118092
    )
}
extension MKCoordinateRegion {
    static var london = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.509865,
            longitude: -0.118092
        ),
        span: .init(latitudeDelta: 2, longitudeDelta: 2)
    )
}
