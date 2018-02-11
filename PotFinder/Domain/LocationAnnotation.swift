//
//  LocationAnnotation.swift
//  GoogleToolboxForMac
//
//  Created by Abhinash Khanal on 2/11/18.
//

import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let location: Location

    init(location: Location) {
        self.location = location
        if let latlongstring = location.coordinates?.split(separator: ",").first {
            let latLongArr = latlongstring.split(separator: ":")
            if let lat = Double(latLongArr[0]), let long = Double(latLongArr[1]) {
                self.coordinate = CLLocationCoordinate2DMake(lat, long)
                return
            }

        }
        self.coordinate = CLLocationCoordinate2DMake(0, 0)
    }
}

