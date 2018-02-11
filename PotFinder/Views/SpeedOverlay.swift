//
//  SpeedOverlay.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/11/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import UIKit
import MapKit

class SpeedOverlay: MKAnnotationView {

    @IBOutlet var trafficoverlay: UIView!

    func updateOverlay(to speed: Int) {

        trafficoverlay.layer.masksToBounds = true
        trafficoverlay.layer.cornerRadius = trafficoverlay.frame.width / 2

        switch speed {
        case 0..<5:
            trafficoverlay.backgroundColor = UIColor.red
        case 5..<15:
            trafficoverlay.backgroundColor = UIColor.orange
        case 15..<20:
            trafficoverlay.backgroundColor = UIColor.yellow
        default:
            trafficoverlay.backgroundColor = UIColor.blue
        }
    }

}

