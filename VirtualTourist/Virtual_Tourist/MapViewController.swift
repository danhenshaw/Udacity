//
//  MapViewController.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Foundation

class MapViewController: createAlert, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    private let pinIdentifier = "pinID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        getPinLocationsFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // RESTORE MAP VIEW SETTINGS
        
        if let dict = UserDefaults.standard.dictionary(forKey: "mapRegion01"),
            let myRegion = MKCoordinateRegion(decode: dict as [String : AnyObject]) {
            map.setRegion(myRegion, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // SAVE CURRENT MAP VIEW SETTINGS BEFORE DISAPPEARING
        
        UserDefaults.standard.set(map.region.encode, forKey: "mapRegion01")
    }
    
    // ADD PIN TO MAP WITH LONG PRESS
    
    @IBAction func addPin(_ sender: AnyObject) {

        if sender.state == UIGestureRecognizerState.began {
            
            // GET TARGET LOCATION
            
            let location = sender.location(in: map)
            
            // GET PIN COORDINATES
            
            let coordinates = map.convert(location, toCoordinateFrom: map)
            let annotation = MKPointAnnotation()
            
            // ADD PIN TO MAP
            
            annotation.coordinate = coordinates
            map.addAnnotation(annotation)
            
            // ADD PIN TO CORE DATA
            
            let pin = Pin(context: CoreDataStack.shared.context)
            pin.latitude = Double(coordinates.latitude)
            pin.longitude = Double(coordinates.longitude)
            CoreDataStack.shared.save()
        }
    }
        
    // TAP ON EXISTING PIN
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let annotation = view.annotation {
            var pin: Pin!
            let latitude = Double(annotation.coordinate.latitude)
            let longitude = Double(annotation.coordinate.longitude)
            
            // GET PIN COORDINATES
            
            do {
                let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
                let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", argumentArray: [latitude, longitude])
                fetchRequest.predicate = predicate
                let pins = try CoreDataStack.shared.context.fetch(fetchRequest)
                if let foundLocation = pins.first {
                    pin = foundLocation
                }
            } catch let error as NSError {
                createAlert("Failed to get pin location: \(error.localizedDescription)")
            }
            
            // DESELECT PIN
            
            mapView.deselectAnnotation(annotation, animated: false)
            
            // SEQUE TO PHOTO ALBUM VIEW CONTROLLER
            
            if let controller = self.storyboard!.instantiateViewController(withIdentifier: "albumVC") as? PhotoAlbumViewController{
                controller.pin = pin
                navigationController!.pushViewController(controller, animated: true)
            }
        }
    }
    
    // GET PIN LOCATION FROM CORE DATA
    
    func getPinLocationsFromCoreData() {
        
        var pins = [Pin]()
        var annotations = [MKAnnotation]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        // CONFIRM IF PINS HAVE ALREADY BEEN SAVED TO CORE DATA
        
        do {
            let results = try CoreDataStack.shared.context.fetch(fetchRequest)
            if let results = results as? [Pin] {
                pins = results
            }
        } catch {
            createAlert("Unable to load pin locations from core data")
        }
        
        // ADD PIN LOCATIONS TO MAP
        
        for (_,pin) in pins.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude), longitude: CLLocationDegrees(pin.longitude))
        annotations.append(annotation)
        }
        map.addAnnotations(annotations)
    }
}
