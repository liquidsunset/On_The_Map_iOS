//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Daniel Brand on 20.06.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation

extension UdacityClient {

    struct Constants {
        static let BaseURLSecure = "https://www.udacity.com/api/"
    }

    struct Methods {
        static let User = "users/{id}"
        static let Session = "session"
    }

    struct URLKeys {
        static let UserID = "id"
    }

    struct JsonBodyKeys {
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }

    struct JsonResponseKey {
        static let Account = "account"
        static let Session = "session"
        static let Id = "id"
        static let Key = "key"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }

}