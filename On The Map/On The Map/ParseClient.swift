//
//  ParseClient.swift
//  On The Map
//
//  Created by Daniel Brand on 20.06.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation

class ParseClient {

    static let sharedInstance = ParseClient()

    func getStudentLocations(completionHandler: (success:Bool, errorMessage:String?) -> Void) {

        let urlParameters = [URLParameterKeys.Limit: 100, URLParameterKeys.Order: "-updatedAt"]
        let url = NSURL(string: Constants.BaseURLSecure + Methods.StudentLocation + Utility.escapedParameters(urlParameters))

        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard (error == nil) else {
                completionHandler(success: false, errorMessage: error?.description)
                return
            }

            guard let data = data else {
                completionHandler(success: false, errorMessage: "No data received")
                return
            }

            Utility.parseJSONWithCompletionHandler(data) {
                (parsedJsonResult, error) in
                guard (error == nil) else {
                    completionHandler(success: false, errorMessage: "Failed to parse data")
                    return
                }

                guard let parsedJsonResult = parsedJsonResult else {
                    completionHandler(success: false, errorMessage: "Failed to parse data")
                    return
                }

                if let results = parsedJsonResult[JsonResponseKey.Results] as? [[String:AnyObject]] {
                    StudentInformation.studentInformationArray.removeAll()
                    let studentInfo = StudentInformation.addStudentsFromResult(results)
                    guard (!studentInfo.isEmpty) else {
                        completionHandler(success: false, errorMessage: "Failed to get student infos from result")
                        return
                    }

                    completionHandler(success: true, errorMessage: nil)
                } else {
                    completionHandler(success: false, errorMessage: "Failed to parse data")
                }

            }
        }

        task.resume()
    }

    func addNewLocation(mapString: String, mediaUrl: String, completionHandler: (success:Bool, errorMessage:String?) -> Void) {
        let url = NSURL(string: Constants.BaseURLSecure + Methods.StudentLocation)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance.userID)\", \"firstName\": \"\(UdacityClient.sharedInstance.firstName)\", \"lastName\": \"\(UdacityClient.sharedInstance.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard error == nil else {
                completionHandler(success: false, errorMessage: error?.description)
                return
            }

        }
        
        task.resume()
    }
}