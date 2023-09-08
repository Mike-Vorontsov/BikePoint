////
////  StationsMapView.swift
////  BikePoint
////
////  Created by Mykhailo Vorontsov on 08/09/2023.
////
//
//import SwiftUI
//import MapKit
//
//struct StationsMapView: View {
//    @State var region: MKCoordinateRegion
//    var body: some View {
////        Map(coordinateRegion: $region) { _ in
////            MapMarker(coordinate: MKCoordinateRegion.london.center)
////        }
//        
//        Map {
//            
//            Marker(
//                "San Francisco City Hall",
//                coordinate: CLLocationCoordinate2D.cityHallLocation)
//            .tint(.orange)
//            
//                        Marker("San Francisco Public Library", coordinate: publicLibraryLocation)
//                            .tint(.blue)
//                        Annotation("Diller Civic Center Playground", coordinate: playgroundLocation) {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 5)
//                                    .fill(Color.yellow)
//                                Text("🛝")
//                                    .padding(5)
//                            }
//                        }
//                    }
//                    .mapControlVisibility(.hidden)
//    }
//}
//
//struct StationsMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationsMapView(region: .london)
//    }
//}
//
//extension CLLocationCoordinate2D {
//    static var cityHallLocation  = CLLocationCoordinate2D(
//        latitude: 51.509865,
//        longitude: -0.118092
//    )
//}
//extension MKCoordinateRegion {
//    static var london = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 51.509865,
//            longitude: -0.118092
//        ),
//        span: .init(latitudeDelta: 2, longitudeDelta: 2)
//    )
//}
