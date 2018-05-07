//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

 import Foundation

struct Student {
    
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    init(studentDictionary: [String: AnyObject]) {
        uniqueKey = studentDictionary[Constants.StudentLocation.uniqueKey] as? String ?? ""
        firstName = studentDictionary[Constants.StudentLocation.firstName] as? String ?? ""
        lastName = studentDictionary[Constants.StudentLocation.lastName] as? String ?? ""
        mediaURL = studentDictionary[Constants.StudentLocation.mediaURL] as? String ?? ""
        latitude = studentDictionary[Constants.StudentLocation.latitude] as? Double ?? 0
        longitude = studentDictionary[Constants.StudentLocation.longitude] as? Double ?? 0
        
    }
    
    init() {

    }
}

struct Students {
    
    static var studentsArray = [[String: AnyObject]]()
    
}

