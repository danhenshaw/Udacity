//
//  CreateAlert.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 7/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createAlert(_ error: String) {
        
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
        
        present(alert, animated: true, completion: nil)
    }
}
