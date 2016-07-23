//
//  MapViewController.swift
//  On The Map
//
//  Created by Daniel Brand on 18.07.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!

    override func viewWillAppear(animated: Bool) {
        mapView.delegate = self
        super.viewWillAppear(animated)
        refresh()
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle {
                let studentURL = NSURL(string: toOpen!)
                guard (studentURL != nil) else {
                    self.performUpdatesOnMain() {
                        self.showAlertMessage("URL-Error", message: "No valid URL")
                    }
                    return
                }
                app.openURL(studentURL!)
            }
        }
    }

    //http://stackoverflow.com/questions/10865088/how-do-i-remove-all-annotations-from-mkmapview-except-the-user-location-annotati
    private func removeAnnotations() {
        let annotationsToRemove = mapView.annotations.filter {
            $0 !== mapView.userLocation
        }
        mapView.removeAnnotations(annotationsToRemove)
    }

    private func displayStudentPins() {
        let studentsInfo = StudentInformation.studentInformationArray

        var annotations = [MKPointAnnotation]()

        for student in studentsInfo {
            let annotation = MKPointAnnotation()

            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL

            let latidude = CLLocationDegrees(student.latitude)
            let longitude = CLLocationDegrees(student.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latidude, longitude: longitude)

            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)

    }

    private func refresh() {
        ParseClient.sharedInstance.getStudentLocations() {
            (success, error) in
            self.performUpdatesOnMain() {
                guard (error == nil) else {
                    self.showAlertMessage("Location-Data Error", message: error!)
                    return
                }

                self.removeAnnotations()
                self.displayStudentPins()
            }
        }
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        UdacityClient.sharedInstance.logout() {
            (success, error) in

            guard (error == nil) else {
                self.showAlertMessage("Logout-Error", message: error!)
                return
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func refreshPressed(sender: AnyObject) {
        refresh()
    }

    @IBAction func addNewLocation(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("NewLocationController")
        let navigation = UINavigationController(rootViewController: controller!)
        navigationController?.presentViewController(navigation, animated: true, completion: nil)
    }
}
