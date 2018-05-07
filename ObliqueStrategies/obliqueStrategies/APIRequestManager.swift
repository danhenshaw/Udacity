//
//  APIRequestManager.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 7/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

class APIRequestManager {
    
    var singleObliqueStrategyID: Int!
    var singleObliqueStrategyEdition: Int!
    var singleObliqueStrategyCardNumber: Int!
    var singleObliqueStrategyStrategy: String!
    
    var specificObliqueStrategyID: Int!
    var specificObliqueStrategyEdition: Int!
    var specificObliqueStrategyCardNumber: Int!
    var specificObliqueStrategyStrategy: String!
    
    var obliqueStrategyIDFromTableView: Int!
    
    
    // DOWNLOAD MULTIPLE OBLIQUE STRATEGY CARDS FROM WEB API
    
    func GETtingObliqueStrategies(GETtingObliqueStrategiesCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "http://brianeno.needsyourhelp.org/all")!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
    
            guard (error == nil) else {
                GETtingObliqueStrategiesCompletionHandler(false, errorStrings.cantFetchParse)
                return
            }
    
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                GETtingObliqueStrategiesCompletionHandler(false, errorStrings.statusCodeError)
                return
            }
    
            guard let data = data else {
                GETtingObliqueStrategiesCompletionHandler(false, errorStrings.dataError)
                return
            }
    
            let parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } catch {
                GETtingObliqueStrategiesCompletionHandler(false, errorStrings.parseError)
                return
            }
    
            guard let results = parsedResult as? [[String:AnyObject]] else {
                GETtingObliqueStrategiesCompletionHandler(false, errorStrings.noResultError)
                return
            }
    
            ObliqueStrategies.dataArray = results
            
            GETtingObliqueStrategiesCompletionHandler(true, nil)
    
        }
        
        task.resume()
    }
    
    // DOWNLOAD A SINGLE OBLIQUE STRATEGY CARD FROM WEB API
    
    func GETtingSingleObliqueStrategy(GETtingSingleObliqueStrategyCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "http://brianeno.needsyourhelp.org/draw")!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                GETtingSingleObliqueStrategyCompletionHandler(false, errorStrings.cantFetchParse)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                GETtingSingleObliqueStrategyCompletionHandler(false, errorStrings.statusCodeError)
                return
            }
            
            guard let data = data else {
                GETtingSingleObliqueStrategyCompletionHandler(false, errorStrings.dataError)
                return
            }
            
            print("Single Random Oblique Strategy JSON Response: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)")
            
            let parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } catch {
                GETtingSingleObliqueStrategyCompletionHandler(false, errorStrings.parseError)
                return
            }
            
            guard let singleDictionary = parsedResult as? [String: AnyObject],
                let singleObliqueStrategyID = singleDictionary[JSONResponseKeys.id] as? Int,
                let singleObliqueStrategyEdition = singleDictionary[JSONResponseKeys.edition] as? Int,
                let singleObliqueStrategyCardNumber = singleDictionary[JSONResponseKeys.cardnumber] as? Int,
                let singleObliqueStrategyStrategy = singleDictionary[JSONResponseKeys.strategy] as? String
            
            else {
                GETtingSingleObliqueStrategyCompletionHandler(false, errorStrings.cantFetchUserData)
                return
            }
            
            self.singleObliqueStrategyID = singleObliqueStrategyID
            self.singleObliqueStrategyEdition = singleObliqueStrategyEdition
            self.singleObliqueStrategyCardNumber = singleObliqueStrategyCardNumber
            self.singleObliqueStrategyStrategy = singleObliqueStrategyStrategy

            GETtingSingleObliqueStrategyCompletionHandler(true, nil)
            
        }
        
        task.resume()
    }

    // DOWNLOAD A SPECIFIC OBLIQUE STRATEGY CARD BASED ON CARD ID NUMBER
    
    func GETtingSpecificObliqueStrategy(GETtingSpecificObliqueStrategyCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "http://brianeno.needsyourhelp.org/id/\(obliqueStrategyIDFromTableView!)")!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                GETtingSpecificObliqueStrategyCompletionHandler(false, errorStrings.cantFetchParse)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                GETtingSpecificObliqueStrategyCompletionHandler(false, errorStrings.statusCodeError)
                return
            }
            
            guard let data = data else {
                GETtingSpecificObliqueStrategyCompletionHandler(false, errorStrings.dataError)
                return
            }
            
            print("Specific Oblique Strategy JSON Response: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)")
            
            let parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } catch {
                GETtingSpecificObliqueStrategyCompletionHandler(false, errorStrings.parseError)
                return
            }
            
            guard let singleDictionary = parsedResult as? [String: AnyObject],
                let specificObliqueStrategyID = singleDictionary[JSONResponseKeys.id] as? Int,
                let specificObliqueStrategyEdition = singleDictionary[JSONResponseKeys.edition] as? Int,
                let specificObliqueStrategyCardNumber = singleDictionary[JSONResponseKeys.cardnumber] as? Int,
                let specificObliqueStrategyStrategy = singleDictionary[JSONResponseKeys.strategy] as? String
                
                else {
                    GETtingSpecificObliqueStrategyCompletionHandler(false, errorStrings.cantFetchUserData)
                    return
            }
            
            self.specificObliqueStrategyID = specificObliqueStrategyID
            self.specificObliqueStrategyEdition = specificObliqueStrategyEdition
            self.specificObliqueStrategyCardNumber = specificObliqueStrategyCardNumber
            self.specificObliqueStrategyStrategy = specificObliqueStrategyStrategy
            
            GETtingSpecificObliqueStrategyCompletionHandler(true, nil)
            
        }
        
        task.resume()
    }
    
    
    // SHARED INSTANCE
    
    class func sharedInstance() -> APIRequestManager {
        struct Singleton {
            static var sharedInstance = APIRequestManager()
        }
        return Singleton.sharedInstance
    }
}
