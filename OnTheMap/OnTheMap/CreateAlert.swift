//
//  CreateAlert.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 28/9/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit


func createAlert(_ viewController: UIViewController, error: String) {
    let alert = UIAlertController(title: "Warning", message: error, preferredStyle: .alert)
    
    let dismissButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { (action) -> Void in
        alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(dismissButton)
    viewController.present(alert, animated: true, completion: nil)
}
