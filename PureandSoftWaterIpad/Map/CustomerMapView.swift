//
//  MapView.swift
//  MapView
//
//  Created by Tom Dolson on 9/9/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import SwiftUI
import MapKit

struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)

struct CustomerMapView: View {
    
    //@Environment(\.presentationMode) var presentationMode
    
    //var onDismiss: () -> ()
    
    var name: String = "Tom Dolson"
    var address = "16 Homestead Street, Hillsdale, NJ 07642"
    @State var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.0016818, longitude: -74.020898)
    
    func getCoords(address: String) -> CLLocationCoordinate2D {
        var lat: Double = 41.0016818
        var lon: Double = -74.020898
        
        DispatchQueue.main.async {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { placemarks, error in
                let placemark = placemarks?.first
                lat = (placemark?.location?.coordinate.latitude)!
                lon = (placemark?.location?.coordinate.longitude)!
                
                coordinates = CLLocationCoordinate2D(latitude: lat,longitude: lon)
            }
        }
        return coordinates
    }
    
    func close() {
        //presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                
                Text("\(name)  -  \(address)")
                    .font(.system(size: 16))
                    .bold()
                    .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.blue, radius: 3)
                    .padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                Button(action: {
                    
                    self.close()
                    
                }) {
                    Text("Close")
                    
                        .foregroundColor(.red)
                }.buttonStyle(BorderlessButtonStyle())
                    .padding(.init(top: 10, leading: 5, bottom: 0, trailing: 5))
                
                VStack {
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: getCoords(address: address) , span: span)), interactionModes: [.all], showsUserLocation: true, annotationItems: [
                        City(name: name, coordinate: coordinates)
                    ]) {
                        MapMarker(coordinate: $0.coordinate)
                        
                    }.cornerRadius(10)
                        .shadow(color: Color.blue, radius: 3)
                        .padding(.init(top: 10, leading: 20, bottom: 20, trailing: 20))
                        .frame(width: geo.size.width, height: geo.size.height-100,  alignment: .center)
                    
                }
                
            }
            .interactiveDismissDisabled()
            
        }
    }
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                      completion(nil)
                      return
                  }
            completion(location)
        }
    }
    
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

struct CustomerMapView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerMapView()
    }
}
