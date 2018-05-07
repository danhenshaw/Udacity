//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit
import MapKit
 
// class MapViewController: UIViewController, MKMapViewDelegate {
class MapViewController: UIViewController {
    // OUTLETS
    
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var pinButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotationsToMap()
        activityIndicator.isHidden = true
        mapView.delegate = self
    }
    
        // SHOW STUDENT LOCATIONS WITH MAP ANNOTATIONS
    
    func addAnnotationsToMap() {
        
        let studentInformation = Students.studentsArray
        
        for dictionary in studentInformation {
            
            let student = Student(studentDictionary: dictionary)
            
            print("Student: \(student)")
            
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)

            
        }
        
        mapView.addAnnotations(annotations)
        
        DispatchQueue.main.async (execute: {
            self.mapView.addAnnotations(self.annotations)
        })
        
    }
    
    // PIN BUTTON REDIRECTS YOU TO THE ADD LOCATION VIEW CONTROLLER
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationTabBarController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    // LOGOUT BUTTON
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        UdacityClient.sharedInstance().DELETEingSession{ (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    performUpdatesOnMain {
                        createAlert(self, error: errorString!)
                    }
                }
            }
        }
    }
    
        // REFRESH BUTTON

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
        startAnimatingActivityIndicator()
        self.mapView.removeAnnotations(mapView.annotations)
        UdacityClient.sharedInstance().GETtingStudentLocations { (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                    self.addAnnotationsToMap()
                    self.stopAnimatingActivityIndicator()
                } else {
                    performUpdatesOnMain {
                        createAlert(self, error: errorString!)
                        self.stopAnimatingActivityIndicator()
                    }
                }
            }
        }
    }
}

    

extension MapViewController: MKMapViewDelegate {
    
    // MAP VIEW DELEGATE

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let reuseID = "PinID"
        
        var mapPin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
    
        if mapPin == nil {
        
            mapPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            mapPin?.animatesDrop = true
            mapPin?.pinTintColor = .red
            mapPin?.canShowCallout = true
        
            let rightButton = UIButton(type: .detailDisclosure)
            mapPin?.rightCalloutAccessoryView = rightButton
        
            } else {
            
                mapPin?.annotation = annotation
            
            }
            return mapPin
        }

   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            guard var mediaURL = view.annotation?.subtitle! else {
                return
            }
                if (!mediaURL.contains("http://") && !mediaURL.contains("https://")){
                    mediaURL = "http://\(mediaURL)"
                }
            UIApplication.shared.open(URL(string: mediaURL as String)! as URL, options: [:], completionHandler: nil)
            }
        }
    }

// ACTIVTY INDICATOR

private extension MapViewController {
    
    func startAnimatingActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.alpha = 1.0
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimatingActivityIndicator() {
        activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0.0
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

