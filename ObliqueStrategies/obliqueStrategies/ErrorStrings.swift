//
//  Constants.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 7/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

struct errorStrings {
    static let errorString = "Error: Something went wrong with your request."
    static let checkConnection = "Please check your internet connection."
    static let cantFetchParse = "\(errorString) Unable to fetch data. \(checkConnection)"
    static let cantFetchUserData = "\(errorString) Unable to get user data. \(checkConnection)"
    static let statusCodeError = "\(errorString) Your status code does not conform."
    static let dataError = "\(errorString) The request returned no data."
    static let parseError = "\(errorString) Could not convert data."
    static let noResultError = "\(errorString) No result found."
    static let noCardSelected = "No Oblique Strategy card selected"
}
