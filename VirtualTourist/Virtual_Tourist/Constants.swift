//
//  Constants.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

// MARK: - Constants

struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatitudeRange = (-90.0, 90.0)
        static let SearchLongitudeRange = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "c43b31b19b584d6c54c0130998b57f6b"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "2"
        static let PhotosPerPage = "30"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}

