//
//  ReportPotHoleViewController.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class ReportPotHoleViewController: UIViewController {

    var location: CLLocation?
    var reportImage: UIImage?
    let imagePicker = UIImagePickerController()
//    var imageName: String?
    var zipcode: String?
    var address: String?
    var imageData: String?

    let ref = Database.database().reference()

    var user: User?

    let storageRef = Storage.storage().reference()

    @IBOutlet weak var reportedLocationLabel: UILabel!
    @IBOutlet weak var userNotes: UITextView!
    @IBOutlet weak var reportedImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!



    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userDidTapAddImage(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
//        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func userDidTapReport(_ sender: Any) {
        var potHole = PotHoleDomain(JSON: [String:Any?]())
        potHole?.lattitude = self.location?.coordinate.latitude
        potHole?.longitude = self.location?.coordinate.longitude
        potHole?.userId = self.user?.uid
        potHole?.zipcode = self.zipcode
        potHole?.address = self.address
        potHole?.imageData = self.imageData
        let childpath = "zipcodes/\(zipcode ?? "unlisted")/\(Int(1000 * Date().timeIntervalSince1970))"
//        print(childpath)
        ref.child(childpath).setValue(potHole?.toJSON())
        alertSuccess()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.title = "Submit Report"

        guard let location = self.location else {
            return
        }
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { [weak self](marker, error) in
            if (error != nil ) {
//                print("Error")
            } else {
                if let marker = marker?.first {
                    self?.reportedLocationLabel.text = "Reporting a pothole at: \(marker.name ?? "Your current location")"
                    self?.zipcode = marker.postalCode
                    self?.address = marker.name
                }
            }
        }
    }

    func alertSuccess() {
        let successAlert = UIAlertController(title: "Congratulation!",
                                             message: "Your report has been submitted to the authorities!",
                                             preferredStyle: .alert)

        let doneAction = UIAlertAction(title: "Ok",
                                       style: .default) { (_) in
                                        self.navigationController?.popViewController(animated: true)
        }

        successAlert.addAction(doneAction)
        present(successAlert, animated: true, completion: nil)

    }

    func alertFailure() {
        let successAlert = UIAlertController(title: "Error!",
                                             message: "Something went worng. Please try again!",
                                             preferredStyle: .alert)

        let doneAction = UIAlertAction(title: "Ok",
                                       style: .default) { (_) in
        }

        successAlert.addAction(doneAction)
        present(successAlert, animated: true, completion: nil)
    }
}

extension ReportPotHoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.reportImage = image
            self.reportedImageView.image = image
            self.reportedImageView.isHidden = false
            
            if let data = UIImageJPEGRepresentation(image, 0.2) {
                self.imageData = data.base64EncodedString(options: .lineLength64Characters)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
