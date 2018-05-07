//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation

func performUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
