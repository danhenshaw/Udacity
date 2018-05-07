//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 20/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//


 
/*
 
 import Foundation
import UIKit

extension UdacityClient {
    
    func authenticateWithViewController(_ username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        taskForPOSTMethodUdacity() { (success, errorString) in
            if success {
//                if let userID = userID {
                    self.getUserData(){ (success, errorString) in                        completionHandlerForAuth(success, errorString)
                    }
                } else {

                completionHandlerForAuth(success, errorString)
            }
        }
        
    }

func getUserID(_ completionHandlerForGetUserID: @escaping (_ success: Bool,_ userID: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForPOSTMethodUdacity() { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForGetUserID(false, nil, "Error: login unsuccessful")
            } else {
                if let account = result?["account"] as? [String:AnyObject] {
                    if let userID = account["key"] as? String {
                        print ("User ID: \(userID)")
                        Constants.LoginData.uniqueKey = userID
                        completionHandlerForGetUserID(true, userID, nil)
                    } else {
                        print ("Error: user ID not found")
                        completionHandlerForGetUserID(false, nil, "Login unsuccessful")
                    }
                } else {
                    print("Error: account not found")
                    completionHandlerForGetUserID(false, nil, "Login unsuccessful")
                }
            }
            
        }
    }
    

     func getUserData(userID: String?, _ completionHandlerForGetUserData: @escaping (_ success: Bool, _ userData: [String:AnyObject]?, _ errorString: String?) -> Void) {
        let userID = userID!
        let _ = taskForGETPublicUserDataUdacity(userID: userID) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForGetUserData(false, nil, "Error: getting user data unsuccessful")
            } else {
                let userResult = result
                if let userData = userResult["user"] as? [String:AnyObject] {
                    completionHandlerForGetUserData(true, userData, nil)
                } else {
                    print("Error: no user data found")
                }
            }
        }
    }
}
 */
 

