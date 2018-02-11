//
//  SpeedOverlayAnnotation.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/11/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import MapKit


class SpeedOverlayAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var location: EachLocation?

    init(location: EachLocation?) {
        self.location = location
        if let lat = location?.Latitude, let long = location?.Longitude {
//            if let lat = Double(latString), let long = Double(longString) {
                self.coordinate = CLLocationCoordinate2DMake(lat, long)
                return
//            }
        }
        self.coordinate = CLLocationCoordinate2DMake(0, 0)
    }

}
