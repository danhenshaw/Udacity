//
//  MapViewExtension.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//
 
import Foundation
import MapKit

extension MKMapView {
    
    // CENTRE MAP ON PIN LOCATION IN THE PHOTO ALBUM VIEW CONTROLLER
    
    func centerMapOnLocation(pin: Pin, radius: CLLocationDistance) {
        let clLocation = CLLocation(latitude: pin.latitude, longitude: pin.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(clLocation.coordinate, radius * 2.0, radius * 2.0)
        self.setRegion(coordinateRegion, animated: true)
    }
}


