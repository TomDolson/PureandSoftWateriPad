//
//  MapView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 5/24/22.
//  Copyright © 2022 Tom Dolson. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation
//import GoogleMaps
//import GoogleMapsBase


struct MapView: View {
    
    var name: String = "Thomas Dolson"
    var address: String = "1 Glasgow Lane, Suffern, NY 10901"
    
    let latitude = 7.065306
    let longitude = 125.607833
     
    var body: some View {
        VStack {
            EmptyView()
                .scaleEffect(-5)
                    .frame(width: 300, height: 300)
        }
        
        .task {
            await getGoogleMapLocation()
        }
    }
  
    func getGoogleMapLocation() async {
        
        let addressURL = self.address.stringEncode(encodedString: address)
        
        let addressURLNoCommas = addressURL.replacingOccurrences(of: ",", with: "%2C")
        
        let url = URL(string: "comgooglemaps://?origin=&daddr=\(addressURLNoCommas)&directionsmode=driving&dir_action=navigate")
        
        if await UIApplication.shared.canOpenURL(url!) {
            await UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        else {
            let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??origin=daddr=\(addressURLNoCommas))&directionsmode=driving&dir_action=navigate")
            
            await UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

extension String {
    func stringEncode(encodedString: String) -> String {
        let escapedString =
        encodedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return escapedString!
    }
}

//"https://www.google.com/maps/dir/?api=1&origin=16+Homestead+Street%2C
//Hillsdale+NJ&destination=190+Cromwell+Hill+Road%2C+Monroe+NY&travelmode=driving
