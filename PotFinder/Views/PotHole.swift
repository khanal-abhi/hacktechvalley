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
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let potHoleDomain: PotHoleDomain?

    init(potHoleDomain: PotHoleDomain?) {
        self.potHoleDomain = potHoleDomain
        self.coordinate = CLLocationCoordinate2DMake(potHoleDomain?.lattitude ?? 0,
                                                     potHoleDomain?.longitude ?? 0)
        self.title = nil
        self.image = nil
        super.init()
    }
}
