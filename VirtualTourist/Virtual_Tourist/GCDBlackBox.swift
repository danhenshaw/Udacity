//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

func performUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

