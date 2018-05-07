//
//  ActivityIndicator.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 19/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

// CODE ADAPTED FROM http://mpclarkson.github.io/2016/01/06/swift-uiviewcontroller_uiactivityindicator_extension/

import UIKit


extension UIViewController {
    
    var activityIndicatorTag: Int { return 999999 }

    func startActivityIndicator(style: UIActivityIndicatorViewStyle = .gray, location: CGPoint? = nil) {
        
        //Set the position - defaults to `center` if no`location`
        
        //argument is provided
        
        let loc = location ?? self.view.center
        
        //Ensure the UI is updated from the main thread
            
            //Create the activity indicator
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
        
            //Add the tag so we can find the view in order to remove it later
            
            activityIndicator.tag = self.activityIndicatorTag
        
            //Set the location
            
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
        
            //Start animating and add the view
            
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
    }

    func stopActivityIndicator() {
        
            //Here we find the `UIActivityIndicatorView` and remove it from the view
            
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }

