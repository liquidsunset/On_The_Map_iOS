//
//  StudentInformationModel.swift
//  On The Map
//
//  Created by Daniel Brand on 19.07.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation

struct StudentInformation {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float

    static var studentInformationArray = [StudentInformation]()

    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JsonResponseKey.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JsonResponseKey.UniqueKey] as! String
        firstName = dictionary[ParseClient.JsonResponseKey.FirstName] as! String
        lastName = dictionary[ParseClient.JsonResponseKey.LastName] as! String
        mapString = dictionary[ParseClient.JsonResponseKey.MapString] as! String
        mediaURL = dictionary[ParseClient.JsonResponseKey.MediaURL] as! String
        latitude = dictionary[ParseClient.JsonResponseKey.Latitude] as! Float
        longitude = dictionary[ParseClient.JsonResponseKey.Longitude] as! Float
    }

    static func addStudentsFromResult(results: [[String:AnyObject]]) -> [StudentInformation] {
        for result in results {
            studentInformationArray.append(StudentInformation(dictionary: result))
        }

        return studentInformationArray
    }


}