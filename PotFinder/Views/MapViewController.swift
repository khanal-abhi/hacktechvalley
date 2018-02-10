//
//  MapViewController.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class MapViewController: UIViewController {

    var locationManger: CLLocationManager?
    var cam: MKMapCamera?
    var loc: CLLocation?

    let altitude = 1_000.0

    var potHoles = [PotHoleAnnotation]()

    let potholeMarker = "PotHoleMarker"


    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if (locationManger == nil) {
            locationManger = CLLocationManager()
            locationManger?.delegate = self
        }
        locationManger?.requestWhenInUseAuthorization()
        cam = mapView.camera
        mapView.delegate = self

        // Do any additional setup after loading the view.

        var potHole = PotHoleAnnotation(locationName: "Location1",
                                        coordinate: CLLocationCoordinate2D.init(latitude: 42.83, longitude: -73.95),
                                        title: "Location1")
        potHoles.append(potHole)

        potHole = PotHoleAnnotation(locationName: "Location2",
                                        coordinate: CLLocationCoordinate2D.init(latitude: 42.83, longitude: -73.9396),
                                        title: "Location2")
        potHoles.append(potHole)

        potHole = PotHoleAnnotation(locationName: "Location3",
                                        coordinate: CLLocationCoordinate2D.init(latitude: 42.8142, longitude: -73.95),
                                        title: "Location3")
        potHoles.append(potHole)

        potHole = PotHoleAnnotation(locationName: "Location4",
                                        coordinate: CLLocationCoordinate2D.init(latitude: 42.8142, longitude: -73.96),
                                        title: "Location4")
        potHoles.append(potHole)

        potHole = PotHoleAnnotation(locationName: "Location5",
                                        coordinate: CLLocationCoordinate2D.init(latitude: 42.72, longitude: -73.9396),
                                        title: "Location5")
        potHoles.append(potHole)

        mapView.addAnnotations(potHoles)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            if self.loc == nil {
                cam?.centerCoordinate = loc.coordinate
                cam?.altitude = altitude
            }
            self.loc = loc
        }
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PotHoleAnnotation else {
            return nil
        }

        if let dequed = mapView.dequeueReusableAnnotationView(withIdentifier: potholeMarker) as? MKMarkerAnnotationView {
            dequed.image = annotation.image
            dequed.annotation = annotation
            return dequed
        }
        return nil
    }
}
