//
//  NewLocationViewController.swift
//  On The Map
//
//  Created by Daniel Brand on 19.07.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NewLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var userPlacemark: MKPlacemark!


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Location"
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.cancel))
        navigationItem.rightBarButtonItem = cancelButton
        submitButton.hidden = true
        activityIndicator.stopAnimating()
    }

    @IBAction func searchLocation(sender: AnyObject) {

        guard (addressField.text != nil && !(addressField.text?.isEmpty)!) else {
            showAlertMessage("Address-Error", message: "Address field must not be empty")
            return
        }

        let geocoder = CLGeocoder()
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(addressField.text!) {
            (clPlacemarks, error) in
            guard (error == nil) else {
                self.performUpdatesOnMain() {
                    self.showAlertMessage("GeoCoding-Error", message: (error?.localizedDescription)!)
                }
                return
            }

            guard (clPlacemarks?.count > 0) else {
                self.performUpdatesOnMain() {
                    self.showAlertMessage("GeoCoding-Error", message: "No results found")
                }
                return
            }

            self.performUpdatesOnMain() {
                self.activityIndicator.stopAnimating()
                self.submitButton.hidden = false
                self.userPlacemark = MKPlacemark(placemark: clPlacemarks![0])
                self.mapView.addAnnotation(self.userPlacemark)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let zoomToUser = MKCoordinateRegionMake((self.userPlacemark!.location?.coordinate)!, span)
                self.view.endEditing(true)
                self.mapView.setRegion(zoomToUser, animated: true)
            }

        }

    }


    @IBAction func submitLocation(sender: AnyObject) {
        guard (linkField.text != nil && !(linkField.text?.isEmpty)!) else {
            showAlertMessage("Link-Error", message: "Link field must not be empty")
            return
        }

        ParseClient.sharedInstance.addNewLocation(userPlacemark, mapString: addressField.text!, mediaUrl: linkField.text!) {
            (success, error) in
            guard (error == nil) else {
                self.performUpdatesOnMain() {
                    self.showAlertMessage("Location-Error", message: error!)
                }
                return
            }

            guard (success == true) else {
                self.performUpdatesOnMain() {
                    self.showAlertMessage("Location-Error", message: "Failed to post location")
                }
                return
            }

            self.performUpdatesOnMain() {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}