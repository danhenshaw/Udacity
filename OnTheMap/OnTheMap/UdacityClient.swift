//
//  Networking.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

// NETWORKING

import Foundation

class UdacityClient {
    
    var udacitySessionID: String!
    var currentUser = Student()
    
    // AUTHENTICATE WITH VIEW CONTROLLER BY OBTAINING SESSION ID AND RETREIVING MULTIPLE STUDENT LOCATIONS
    
    func authenticateWithViewController(_ username: String, password: String,authenticateWithViewControllerCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.POSTingSession(username, password: password) { (success, errorString) -> Void in
            if success{
                self.GETtingStudentLocations(){ (success, errorString) in
                    authenticateWithViewControllerCompletionHandler(true, nil)
                }
            } else {
                authenticateWithViewControllerCompletionHandler(success, errorString)
            }
        }
    }
    
    // OBTAIN SESSION ID TO AUTHENTICATE UDACITY API REQUESTS
    
    func POSTingSession(_ username: String, password: String, POSTingSessionCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) -> URLSessionTask {
        
            let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(Constants.LoginData.username)\", \"password\": \"\(Constants.LoginData.password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                POSTingSessionCompletionHandler(false, error?.localizedDescription)
                return
            }
            
            guard let data = data else {
                POSTingSessionCompletionHandler(false, Constants.errorStrings.dataError)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                POSTingSessionCompletionHandler(false, Constants.errorStrings.invalidCredentials)
                return
            }
            
          let range = Range(5..<data.count)
            
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedData : [String:AnyObject]!
            
                do {
                    parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                    
                } catch {
                    POSTingSessionCompletionHandler(false, Constants.errorStrings.parseError)
                    return
                }

            guard let accountDictionary = parsedData[Constants.JSONResponseKeys.account] as? [String: AnyObject],
                let sessionDictionary = parsedData[Constants.JSONResponseKeys.session] as? [String: AnyObject],
                let userID =  accountDictionary[Constants.JSONResponseKeys.key] as? String,
                let sessionID = sessionDictionary[Constants.JSONResponseKeys.id] as? String
                
                    else {
                   POSTingSessionCompletionHandler(false, Constants.errorStrings.invalidCredentials)
                    return
                }

            self.currentUser.uniqueKey = userID
            self.udacitySessionID = sessionID
            
            print("Current User Unique Key: \(self.currentUser.uniqueKey!)")
            print("Udacity Session ID: \(self.udacitySessionID!)")

            POSTingSessionCompletionHandler(true, nil)
            
        }
        
        task.resume()
        return task
    }
    
    // RETREIVE BASIC USER INFORMATION BEFORE POSTING DATA TO PARSE  
    
    func GETtingPublicUserData(_ GETtingPublicUserDataCompletionHandler: @ escaping (_ success: Bool, _ errorString: String?) -> Void) -> URLSessionTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(currentUser.uniqueKey!)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                GETtingPublicUserDataCompletionHandler(false, Constants.errorStrings.cantFetchUserData)
                    return
                }
                guard let data = data else {
                        GETtingPublicUserDataCompletionHandler(false, Constants.errorStrings.dataError)
                    return
                }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)

            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedData : [String:AnyObject]!
           
                do {
                    parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                        }catch {
                            GETtingPublicUserDataCompletionHandler(false, Constants.errorStrings.parseError)
                        return
                    }
            
            guard let userDictionary = parsedData[Constants.JSONResponseKeys.user] as? [String: AnyObject],
            let firstName = userDictionary[Constants.JSONResponseKeys.firstName] as? String,
            let lastName = userDictionary[Constants.JSONResponseKeys.lastName] as? String
    
                else {
                    GETtingPublicUserDataCompletionHandler(false, Constants.errorStrings.cantFetchUserData)
                        return
                    }
            
            self.currentUser.firstName = firstName
            self.currentUser.lastName = lastName
            
            print("Current User First Name: \(self.currentUser.firstName!)")
            print("Current User Last Name: \(self.currentUser.lastName!)")
            
            GETtingPublicUserDataCompletionHandler(true, nil)
        }
        
        task.resume()
        return task
    }
    
    // DELETE THE SESSION ID TO "LOGOUT"
    
    
    func DELETEingSession(DELETEingSessionCompletionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                DELETEingSessionCompletionHandler(false, Constants.errorStrings.cantLogout)
                    return
                }
            
            guard let data = data else {
                DELETEingSessionCompletionHandler(false, Constants.errorStrings.dataError)
                    return
                }
        
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedData : [String:AnyObject]!

                do {
                    parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                    let sessionDictionary = parsedData["session"]
                    self.udacitySessionID! = sessionDictionary?["id"] as! String
                    
                    print("Logout successful.")
                    
                } catch {
                    DELETEingSessionCompletionHandler(false, Constants.errorStrings.parseError)
                        return
                    }
            
                DELETEingSessionCompletionHandler(true, nil)
            }
        
        task.resume()
        return task
    }

    // SHARED INSTANCE
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
