//
//  PotHole.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import UIKit
import MapKit

class PotHoleAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?

    init(locationName: String, coordinate: CLLocationCoordinate2D, title: String? = nil) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.title = title
        self.image = nil

        super.init()
    }
}
