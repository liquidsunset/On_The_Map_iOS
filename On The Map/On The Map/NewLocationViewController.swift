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
        self.title = "Add New Location"
        let cancelButton =  UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.cancel))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @IBAction func searchLocation(sender: AnyObject) {
        
        let geocoder = CLGeocoder()
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(addressField.text!) {
            (clPlacemarks, error) in
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertMessage("GeoCoding-Error", message: (error?.localizedDescription)!)
                })
                return
            }
            
            guard (clPlacemarks?.count > 0) else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertMessage("GeoCoding-Error", message: "No results found")
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
                self.userPlacemark = MKPlacemark(placemark: clPlacemarks![0])
                self.mapView.addAnnotation(self.userPlacemark)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let zoomToUser = MKCoordinateRegionMake((self.userPlacemark!.location?.coordinate)!, span)
                self.view.endEditing(true)
                self.mapView.setRegion(zoomToUser, animated: true)
            })
        
        }
        
    }
    
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        
    }
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(ok)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}