//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation
import MapKit

extension UdacityClient {
    
    // GET MULTIPLPE STUDENT LOCATIONS AT ONE TIME
    
    func GETtingStudentLocations(GETtingStudentLocationsCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(Constants.StudentLocation.studentLocationURL)\(Constants.StudentLocation.limit)\(Constants.StudentLocation.sort)")!)
        request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                GETtingStudentLocationsCompletionHandler(false, Constants.errorStrings.cantFetchParse)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                GETtingStudentLocationsCompletionHandler(false, Constants.errorStrings.statusCodeError)
                return
            }
            guard let data = data else {
                GETtingStudentLocationsCompletionHandler(false, Constants.errorStrings.dataError)
                return
            }
            
            let parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                GETtingStudentLocationsCompletionHandler(false, Constants.errorStrings.parseError)
                return
            }
            
            guard let results = parsedResult[Constants.JSONResponseKeys.results] as? [[String:AnyObject]] else {
                GETtingStudentLocationsCompletionHandler(false, Constants.errorStrings.noResultError)
                return
            }
            
//          studentsArray = results
            Students.studentsArray = results
            
            print("Students Array: \(Students.studentsArray)")
            print("Students Array Count: \(Students.studentsArray.count)")
            
            GETtingStudentLocationsCompletionHandler(true, nil)

        }
        
        task.resume()
    }

    
    // GET SINGLE STUDENTS LOCATION
    
    func GETtingASingleStudentLocation(GETtingASingleStudentLocationCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> URLSessionDataTask) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                GETtingASingleStudentLocationCompletionHandler(false, Constants.errorStrings.cantFetchParse)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                GETtingASingleStudentLocationCompletionHandler(false, Constants.errorStrings.statusCodeError)
                return
            }
            
            guard let data = data else {
                GETtingASingleStudentLocationCompletionHandler(false, Constants.errorStrings.dataError)
                return
            }
            
            GETtingASingleStudentLocationCompletionHandler(true, nil)
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
        }
        
        task.resume()
    }
    
    // CREATE A NEW STUDENT LOCATION
    
    func POSTingStudentLocation(_ mapString: String, latitude: Double, longitude: Double, mediaURL: String, POSTingStudentLocationCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.StudentLocation.studentLocationURL)!)
        request.httpMethod = "POST"
        request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(self.currentUser.uniqueKey!)\", \"firstName\": \"\(self.currentUser.firstName!)\", \"lastName\": \"\(self.currentUser.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                POSTingStudentLocationCompletionHandler(false, Constants.errorStrings.cantPostDataParse)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                POSTingStudentLocationCompletionHandler(false, Constants.errorStrings.statusCodeError)
                return
            }
            
            guard let data = data else {
                POSTingStudentLocationCompletionHandler(false, Constants.errorStrings.dataError)
                return
            }
            
            POSTingStudentLocationCompletionHandler (true, nil)
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
        }
        
        task.resume()
    }
    

}
