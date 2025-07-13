//
//  ShowCustomersOnMap.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/11/24.
//  Copyright © 2024 Tom Dolson. All rights reserved.
//


import SwiftUI
import Foundation
import CoreLocation
//import GoogleMaps
//
//struct CustomerAnnotation {
//    let count: Int
//    let name: String
//    let address: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//struct GoogleMapView: UIViewRepresentable {
//    var annotations: [CustomerAnnotation]
//    
//    let newYorkCity = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
//    let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
//    let tokyo = CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)
//    let sydney = CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
//    let rioDeJaneiro = CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729)
//
//
//    func makeUIView(context: Context) -> GMSMapView {
//        let mapView = GMSMapView()
//
//        // Set the initial camera position (example coordinates)
//        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10.0)
//        mapView.camera = camera
//
//        return mapView
//    }
//
//    func updateUIView(_ mapView: GMSMapView, context: Context) {
//        mapView.clear() // Clear existing annotations
//
//        for annotation in annotations {
//            let marker = GMSMarker()
//            marker.position = annotation.coordinate
//            marker.title = "\(annotation.count) - \(annotation.name)"
//            marker.snippet = annotation.address
//            marker.map = mapView
//        }
//    }
//}
//
//struct GoogleMapView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        GoogleMapView(annotations: [CustomerAnnotation.init(count: 1, name: "Tom Dolson", address: "16 Homestead Street, Hillsdale, NJ 07642", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060))])
//    }
//}



//Google Maps API Key = "AIzaSyCG63RJRuS5XchYCiZ9ODWQc3VikWYNVaU"
