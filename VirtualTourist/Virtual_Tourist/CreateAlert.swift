//
//  CreateAlert.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 1/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit

class createAlert: UIViewController {

    func createAlert(_ error: String) {

        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))

        present(alert, animated: true, completion: nil)
        }
    }
