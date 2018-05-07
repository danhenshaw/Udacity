//
//  FlickrManager.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

class FlickrManager: NSObject {
    
    var session = URLSession.shared
    
    func searchByLocation(pin: Pin, completionHandlerForSearchByLocation: @escaping (_ result: [String]?, _ error: String?) -> Void) {
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(pin: pin),
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PhotosPerPage,
            Constants.FlickrParameterKeys.Page: "\(arc4random_uniform(10) + 1)",
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        getPhotos(methodParameters as [String : AnyObject]) { (results, error) in
            if let error = error {
                completionHandlerForSearchByLocation(nil, error)
            } else {
                completionHandlerForSearchByLocation(results, nil)
            }
        }
    }
    
    private func bboxString(pin: Pin?) -> String {
        
        // CONFIGURE BBOX
        
        if let pin = pin {
            let latitude = pin.latitude
            let longitude = pin.longitude
            let minimumLongitude = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLongitudeRange.0)
            let minimumLatitude = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatitudeRange.0)
            let maximumLongitude = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLongitudeRange.1)
            let maximumLatitude = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatitudeRange.1)
            return "\(minimumLongitude),\(minimumLatitude),\(maximumLongitude),\(maximumLatitude)"
        } else {
            return "0,0,0,0"
        }
    }
    
        private func getPhotos(_ methodParameters: [String: AnyObject], completionHandlerForGetPhotos: @escaping (_ result: [String]?, _ error: String?) -> Void) {
        
        // CREATE SESSION AND URL REQUEST
            
        let urlString = "https://api.flickr.com/services/rest/" + formatParameters(methodParameters as [String : AnyObject])
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        // CREATE NETWORK REQUEST
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // GUARD: Was there an error?
            
            guard (error == nil) else {
                completionHandlerForGetPhotos(nil, error?.localizedDescription)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGetPhotos(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            
            guard let data = data else {
                completionHandlerForGetPhotos(nil, "No data was returned by the request!")
                return
            }
            
            // Parse the data
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandlerForGetPhotos(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // GUARD: Did Flickr return an error (stat != ok)?
            
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                completionHandlerForGetPhotos(nil, "Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            // GUARD: Is "photos" key in our result?
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                completionHandlerForGetPhotos(nil, "Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            // GUARD: Is "photos" key in our result?
            
            guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                completionHandlerForGetPhotos(nil, "Cannot find keys '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            // GET PHOTO URL
            
            var photoURLS = [String]()
            for photo in photosArray {
                if let photoURL = photo[Constants.FlickrResponseKeys.MediumURL] as? String {
                    photoURLS.append(photoURL)
                }
            }
            
            completionHandlerForGetPhotos(photoURLS, nil)
        }
        
        task.resume()
    }
    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    fileprivate func formatParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }

    
    // DOWNLOAD PHOTOS FROM URL
    
    func downloadPhotos(photoURL: String, completionHandlerForDownloadPhotos: @escaping (_ image: NSData?, _ error: NSError?) -> Void) {
        let url = NSURL(string: photoURL)
        let request = URLRequest(url: url! as URL)
        
        let task = session.dataTask(with: request){ data, response, error in
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Not able to download photo"]
                completionHandlerForDownloadPhotos(nil, NSError(domain: "downloadPhotos", code: 1, userInfo: userInfo))
                return
            }
            completionHandlerForDownloadPhotos(data as NSData, nil)
        }
        task.resume()
    }
}
