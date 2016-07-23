//
//  TableViewController.swift
//  On The Map
//
//  Created by Daniel Brand on 18.07.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentInformationArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableViewCell", forIndexPath: indexPath)
        let studentInfo = StudentInformation.studentInformationArray[indexPath.row]
        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"

        return cell
    }


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectionStyle = .None

        let selectedStudentInfo = StudentInformation.studentInformationArray[indexPath.row]
        let studentURL = NSURL(string: selectedStudentInfo.mediaURL)

        guard (studentURL != nil) else {
            self.performUpdatesOnMain() {
                self.showAlertMessage("URL-Error", message: "No valid URL")
            }
            return
        }

        UIApplication.sharedApplication().openURL(studentURL!)
    }

    private func refresh() {
        ParseClient.sharedInstance.getStudentLocations() {
            (success, error) in
            self.performUpdatesOnMain() {
                guard (error == nil) else {
                    self.showAlertMessage("Location-Data Error", message: error!)
                    return
                }
                self.tableView.reloadData()
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
