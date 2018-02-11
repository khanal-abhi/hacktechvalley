//
//  ReportPotHoleViewController.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import UIKit
import CoreLocation

class ReportPotHoleViewController: UIViewController {

    var location: CLLocation?
    var reportImage: UIImage?
    let imagePicker = UIImagePickerController()


    @IBOutlet weak var reportedLocationLabel: UILabel!
    @IBOutlet weak var userNotes: UITextView!
    @IBOutlet weak var reportedImageView: UIImageView!



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
//        imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }


    @IBAction func userDidTapReport(_ sender: Any) {
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
                print("Error")
            } else {
                if let marker = marker?.first {
                    self?.reportedLocationLabel.text = "Reporting a pothole at: \(marker.name ?? "Your current location")"
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
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
