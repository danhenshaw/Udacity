//
//  Constants.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

struct Constants {
    
    struct LoginData {
        static var username = ""
        static var password = ""
        static var uniqueKey = ""
    }
    
    struct StudentData {
        static var studentInformation = [[String:AnyObject]]()
    }
    
    struct CurrentStudent {
        static var mapString = ""
        static var uniqueKey = ""
        static var firstName = "firstName"
        static var lastName = "lastName"
        static var mediaURL = "mediaURL"
        static var objectID = "objectID"
        static var latitude = "latitude"
        static var longitude = "longitude"
        static var sessionID = "sessionID"
    }
 
    struct JSONResponseKeys {
        static let results = "results"
        static let status = "status"
        static let account = "account"
        static let session = "session"
        static let key = "key"
        static let id = "id"
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
    }

    struct StudentLocation {
        
        static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let studentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let limit = "?limit=100"
        static let sort = "&order=-updatedAt"
        
        static var objectID = "objectID"
        static var uniqueKey = "uniqueKey"
        static var firstName = "firstName"
        static var lastName = "lastName"
        static var mapString = "mapString"
        static var mediaURL = "mediaURL"
        static var latitude = "latitude"
        static var longitude = "longitude"
    }
    
    struct errorStrings {
        static let errorString = "Error: Something went wrong with your request."
        static let checkConnection = "Please check internet connection."
        static let cantLoginUdacity = "\(errorString) Unable to Login. \(checkConnection)"
        static let cantFetchParse = "\(errorString) Unable to fetch data from Parse. \(checkConnection)"
        static let cantLogout = "\(errorString) Unable to logout of current session. \(checkConnection)"
        static let noGeocodeResult = "\(errorString) No results returned"
        static let cantFetchUserData = "\(errorString) Unable to get user data from Udacity. \(checkConnection)"
        static let cantPostDataParse = "\(errorString) Unable to post data to Parse. \(checkConnection)"
        static let statusCodeError = "\(errorString) Your status code does not conform to 2xx."
        static let dataError = "\(errorString) The request returned no data."
        static let parseError = "\(errorString) Could not parse data as JSON."
        static let noResultError = "\(errorString) No result found."
        
        static let invalidCredentials = "Account not found or invalid credentials."
        static let noID = "Please enter your username"
        static let noPassword = "Please enter your password"
        static let noIDAndPassword = "Please enter your username and password"
        static let noMediaURL = "Please enter your URL link"
        static let noLocation = "Please enter your location."
    }
    
}


