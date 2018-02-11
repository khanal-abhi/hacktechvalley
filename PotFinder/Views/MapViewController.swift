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
    var user: User?
    var potHoles = [PotHoleAnnotation]()
    var mapPins = [MKPinAnnotationView]()
    var currentPothole: PotHoleAnnotation?

    var vehicles = [SpeedOverlayAnnotation]()
    var sensors = [LocationAnnotation]()

    var address: String?
    var zipcode: String?

    let altitude = 10_000.0

    let potholeMarker = "PotHoleMarker"

    var handle: AuthStateDidChangeListenerHandle? = nil

    let ref = Database.database().reference()



    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var potholeImage: UIImageView!
    @IBOutlet weak var potholeOverlay: UIView!
    @IBOutlet weak var fixPotholeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()


        if let filePath = Bundle.main.path(forResource: "data", ofType: "json") {
            if let content = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe) {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableLeaves)
                    if let jsonTypeResult = jsonResult as? [Any] {
                        let vehicles = JsonData(JSON: ["jsonData": jsonResult])
                        vehicles?.jsonData?.forEach({ (eachloc) in

                            self.vehicles.append(SpeedOverlayAnnotation(location: eachloc))
                        })
                        mapView.addAnnotations(self.vehicles)
                    }
                } catch let err {
//                    print(err)
                }
            }

        } else {
            print("file not found.")
        }
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true

        if (locationManger == nil) {
            locationManger = CLLocationManager()
            locationManger?.delegate = self
        }
        locationManger?.requestWhenInUseAuthorization()
        cam = mapView.camera
        mapView.delegate = self
    }

    func loadPotHoles(for zipcode: String) {
        self.mapView.removeAnnotations(self.potHoles)
        let childpath = "zipcodes/\(zipcode ?? "unlisted")"

        ref.child(childpath).observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if let value = snapshot.value as? [String: Any?] {
                value.keys.forEach({ (key) in
                    if let potHoleData = value[key] as? [String:Any?] {
                        let potHoleDomain = PotHoleDomain(JSON: potHoleData)
                        let potHole = PotHoleAnnotation(potHoleDomain: potHoleDomain)
                        self.potHoles.append(potHole)
                    }

                })

                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.potHoles)
                }

            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Report Pothole"
        handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            guard let it = self else {
                return
            }
            self?.user = user
            if let user = user {

                // Logged in
                if let userEmail = user.email {
                    self?.userLabel.text = userEmail
                    UIView.animate(withDuration: 0.25,
                                   delay: 3,
                                   options: [UIViewAnimationOptions.curveEaseIn],
                                   animations: {
                                    self?.userLabel.alpha = 0
                    }, completion: { (completed) in
                        if completed {
                            self?.userLabel.isHidden = true
                        }
                    })
                }
            } else {
                // Logged out
                self?.navigationController?.popViewController(animated: true)
            }
        })

        if zipcode != nil {
            loadPotHoles(for: zipcode!)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func userDidTapTheFab(_ sender: Any) {
        let actionSheet = UIAlertController(title: "What would you like to do?",
                                            message: "",
                                            preferredStyle: .actionSheet)

        let reportAction = UIAlertAction(title: "Report a pothole", style: .default) {[weak self] (_) in
            //
            if let vc = Bundle.main.loadNibNamed("ReportPotHoleViewController", owner: nil, options: nil)?.first as? ReportPotHoleViewController {
                vc.location = self?.loc
                vc.user = self?.user
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // 
        }

        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func userDidDismissMarker(_ sender: Any) {
        potholeOverlay.isHidden = true
        mapView(mapView, didDeselect: MKAnnotationView(annotation: nil, reuseIdentifier: nil))
    }

    @IBAction func userDidFixPothole(_ sender: Any) {
        potholeOverlay.isHidden = true
        if let cp = currentPothole {
            mapView.removeAnnotation(cp)
            self.potHoles = potHoles.filter({ (ph) -> Bool in
                !(ph.potHoleDomain?.lattitude == cp.potHoleDomain?.lattitude &&
                ph.potHoleDomain?.longitude == cp.potHoleDomain?.longitude)
            })
        }
    }

    @IBAction func userDidToggleTraffic(_ sender: Any) {
        mapView.showsTraffic = !mapView.showsTraffic
    }

    @IBAction func userDidToggleSatelite(_ sender: Any) {
        mapView.mapType = mapView.mapType == .hybrid ? .standard : .hybrid
    }

    @IBAction func updateMap(_ sender: Any) {
        let latDeltaBy2 = (mapView.region.span.latitudeDelta / 2)
        let longDeltaBy2 = (mapView.region.span.longitudeDelta / 2)
        let lat1 = mapView.region.center.latitude - latDeltaBy2
        let long1 = mapView.region.center.longitude - longDeltaBy2
        let lat2 = mapView.region.center.latitude + latDeltaBy2
        let long2 = mapView.region.center.longitude + longDeltaBy2

        let loc = [
            CLLocationCoordinate2D.init(latitude: lat1, longitude: long1),
            CLLocationCoordinate2D.init(latitude: lat2, longitude: long2)
        ]

        ApiService.instance.getAllLocations(for: loc,
                                            onSucess: { (locationResponse) in
                                                print(locationResponse)
                                                DispatchQueue.main.async {
                                                    self.addLocations(locationResponse: locationResponse)
                                                }
        }) { (err) in
            print(err)
        }

        let geocoder = CLGeocoder()
        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geocoder.reverseGeocodeLocation(centerLocation) { (markers, err) in
            if let marker = markers?.first {
                if let zipcode = marker.postalCode {
                    DispatchQueue.main.async {
                        self.loadPotHoles(for: zipcode)
                    }
                }
            }
        }
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

                let geocoder = CLGeocoder()

                geocoder.reverseGeocodeLocation(loc) { [weak self](marker, error) in
                    if (error != nil ) {
//                        print("Error")
                    } else {
                        if let marker = marker?.first {
                            self?.zipcode = marker.postalCode
                            self?.address = marker.name
                            self?.loadPotHoles(for: marker.postalCode ?? "")
                        }
                    }
                }
            }
            self.loc = loc
        }
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PotHoleAnnotation {
            if let dequed = Bundle.main.loadNibNamed("PotHoleAnnotationView", owner: nil, options: nil)?.first as? PotHolePinAnnotationView {
//                dequed.image = annotation.image
//                dequed.annotation = annotation
                return dequed
            }
        } else if let annotation = annotation as? LocationAnnotation {
            let dequed = MKMarkerAnnotationView()
//            if let dequed = mapView.dequeueReusableAnnotationView(withIdentifier: potholeMarker) as? MKMarkerAnnotationView {
                dequed.image = #imageLiteral(resourceName: "sensor")
                dequed.annotation = annotation
                return dequed
        } else
//            if let annotion = annotation as? SpeedOverlayAnnotation
        {

            if let dequed = Bundle.main.loadNibNamed("SpeedOverlay", owner: nil, options: nil)?.first as? SpeedOverlay {
                dequed.updateOverlay(to: (annotation as? SpeedOverlayAnnotation)?.location?.StreetSpeed ?? 0)
                dequed.alpha = 0.1
                return dequed
            }
        }


        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.currentPothole = view.annotation as? PotHoleAnnotation
        if let imageData = self.currentPothole?.potHoleDomain?.imageData {
            if let data = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: data)
                self.potholeImage.image = image
                self.potholeOverlay.isHidden = false
            }
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.potholeOverlay.isHidden = true

    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

//        let latDeltaBy2 = (mapView.region.span.latitudeDelta / 2)
//        let longDeltaBy2 = (mapView.region.span.longitudeDelta / 2)
//        let lat1 = mapView.region.center.latitude - latDeltaBy2
//        let long1 = mapView.region.center.longitude - longDeltaBy2
//        let lat2 = mapView.region.center.latitude + latDeltaBy2
//        let long2 = mapView.region.center.longitude + longDeltaBy2
//
//        let loc = [
//            CLLocationCoordinate2D.init(latitude: lat1, longitude: long1),
//            CLLocationCoordinate2D.init(latitude: lat2, longitude: long2)
//        ]
//
//        ApiService.instance.getAllLocations(for: loc,
//                                            onSucess: { (locationResponse) in
//                                                print(locationResponse)
//                                                DispatchQueue.main.async {
//                                                    self.addLocations(locationResponse: locationResponse)
//                                                }
//        }) { (err) in
//            print(err)
//        }
//
//        let geocoder = CLGeocoder()
//        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
//        geocoder.reverseGeocodeLocation(centerLocation) { (markers, err) in
//            if let marker = markers?.first {
//                if let zipcode = marker.postalCode {
//                    DispatchQueue.main.async {
//                        self.loadPotHoles(for: zipcode)
//                    }
//                }
//            }
//        }
    }

    func addLocations(locationResponse: LocationResponse) {
        mapView.removeAnnotations(sensors)
        self.sensors.removeAll()
        locationResponse.content?.forEach({ (location) in
            sensors.append(LocationAnnotation(location: location))
        })
        mapView.addAnnotations(sensors)
    }
}
