//
//  ParseConstants.swift
//  On The Map
//
//  Created by Daniel Brand on 20.06.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation

extension ParseClient {

    struct Constants {
        static let BaseURLSecure = "https://api.parse.com/1/classes/"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }

    struct Methods {
        static let StudentLocation = "StudentLocation"
    }

    struct URLParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
    }

    struct JsonResponseKey {
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }

}