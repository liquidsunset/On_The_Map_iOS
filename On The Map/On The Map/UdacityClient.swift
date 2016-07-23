//
//  UdacityClient.swift
//  On The Map
//
//  Created by Daniel Brand on 20.06.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation

class UdacityClient {

    static let sharedInstance = UdacityClient()

    var sessionID: String!
    var userID: String!
    var firstName: String!
    var lastName: String!

    func login(username: String, password: String, completionHandler:
            (success:Bool, errorMessage:String?) -> Void) {

        let url = NSURL(string: Constants.BaseURLSecure + Methods.Session)
        let request = NSMutableURLRequest(URL: url!)

        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard (error == nil) else {
                completionHandler(success: false, errorMessage: error?.localizedDescription)
                return
            }

            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode == 403 {
                completionHandler(success: false, errorMessage: "Invalid Username or Password")
                return
            }

            guard let data = data else {
                completionHandler(success: false, errorMessage: "Problem at requesting data!")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

            Utility.parseJSONWithCompletionHandler(newData) {
                (parsedJsonResult, error) in
                guard (error == nil) else {
                    completionHandler(success: false, errorMessage: "Failed to parse data")
                    return
                }

                if let parsedJsonResult = parsedJsonResult {
                    if let session = parsedJsonResult[JsonResponseKey.Session] as? [String:AnyObject] {
                        if let sessionID = session[JsonResponseKey.Id] as? String {
                            self.sessionID = sessionID
                        }
                    }
                    if let account = parsedJsonResult[JsonResponseKey.Account] as? [String:AnyObject] {
                        if let userID = account[JsonResponseKey.Key] as? String {
                            self.userID = userID
                        }
                    }
                }

                guard (self.sessionID != nil && self.userID != nil) else {
                    completionHandler(success: false, errorMessage: "Login Failed")
                    return
                }

                self.getStudentName(self.userID!) {
                    (success, error) in
                    guard (error == nil) else {
                        completionHandler(success: false, errorMessage: error)
                        return
                    }

                    ParseClient.sharedInstance.getStudentLocations() {
                        (success, error) in
                        guard (error == nil) else {
                            completionHandler(success: false, errorMessage: error)
                            return
                        }
                    }

                    completionHandler(success: true, errorMessage: nil)

                }
            }

        }

        task.resume()
    }

    func getStudentName(userID: String, completionHandler: (success:Bool, errorMessage:String?) -> Void) {
        let method = Utility.subtituteKeyInMethod(Methods.User, key: URLKeys.UserID, value: userID)
        let url = NSURL(string: Constants.BaseURLSecure + method!)
        let request = NSMutableURLRequest(URL: url!)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard (error == nil) else {
                completionHandler(success: false, errorMessage: (error?.localizedDescription)!)
                return
            }

            guard let data = data else {
                completionHandler(success: false, errorMessage: "Problem at requesting data!")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

            Utility.parseJSONWithCompletionHandler(newData) {
                (parsedJsonResult, error) in
                guard (error == nil) else {
                    completionHandler(success: false, errorMessage: "Failed to parse data")
                    return
                }

                if let parsedJsonResult = parsedJsonResult {
                    if let user = parsedJsonResult[JsonResponseKey.User] as? [String:AnyObject] {
                        if let firstName = user[JsonResponseKey.FirstName] as? String {
                            self.firstName = firstName
                        }
                        if let lastName = user[JsonResponseKey.LastName] as? String {
                            self.lastName = lastName
                        }
                    }
                }

                guard (self.firstName != nil && self.lastName != nil) else {
                    completionHandler(success: false, errorMessage: "Failed to get user name")
                    return
                }

                completionHandler(success: true, errorMessage: nil)
            }
        }
        task.resume()
    }

    func logout(completionHandler: (success:Bool, errorMessage:String?) -> Void) {
        let url = NSURL(string: Constants.BaseURLSecure + Methods.Session)
        let request = NSMutableURLRequest(URL: url!)

        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            guard (error == nil) else {
                completionHandler(success: false, errorMessage: error?.localizedDescription)
                return
            }
            
            guard let data = data else {
                completionHandler(success: false, errorMessage: "Problem at requesting data!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            self.sessionID = nil
            self.userID = nil
            self.firstName = nil
            self.lastName = nil
            
            completionHandler(success: true, errorMessage: nil)
        }

        task.resume()
    }

}
