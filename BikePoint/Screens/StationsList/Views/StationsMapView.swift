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
    let content: (() -> Content)?
    
    var body: some View {
        Map {
            ForEach(state.markers) { markerState in
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
                        coordinates: londonCenter,
                        title: "London"
                    ),
                    .init(
                        coordinates: greenwich,
                        title: "Greenwich"
                    ),

                ]
            ),
            content: { EmptyView() }
        )
    }
    
    static let londonCenter  = CLLocationCoordinate2D(
        latitude: 51.509865,
        longitude: -0.118092
    )
    
    static let greenwich = CLLocationCoordinate2D(
        latitude: 51.309865,
        longitude: 0
    )

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
