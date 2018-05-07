//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate  {
    
    var keyboardOnScreen = false
    var mapString: String!
    var longitude: Double!
    var latitude: Double!
    var mediaURL: String!
    var placemark: CLPlacemark!
    var currentUser = Student()
    
    // OUTLETS
    
    @IBOutlet var studentURLTextField: UITextField!
    @IBOutlet var studentLocationTextField: UITextField!
    @IBOutlet var findLocationButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        activityIndicator.isHidden = true
        saveButton.isEnabled = false
        }
    
    // FIND LOCATION BUTTON
    
    @IBAction func findLocationButtonPressed(sender: AnyObject) {
        
        if studentLocationTextField.text == "" {
            createAlert(self, error: Constants.errorStrings.noLocation)
            self.studentLocationTextField.becomeFirstResponder()
            return
        }
        
        startAnimatingActivityIndicator()
        
        let geocoder = CLGeocoder()
        
        do {
            geocoder.geocodeAddressString(studentLocationTextField.text!) { (results, error) -> Void in
                if error != nil || results!.isEmpty{
                    performUpdatesOnMain{
                        self.stopAnimatingActivityIndicator()
                        createAlert(self, error: Constants.errorStrings.noGeocodeResult)
                    }
                } else {
                    performUpdatesOnMain {
                        
                        // ADD STUDENT LOCATION AS PLACEMARK ON MAP
                        
                        self.placemark = results![0]
                        self.longitude = self.placemark.location!.coordinate.longitude
                        self.latitude = self.placemark.location!.coordinate.latitude
                        self.mapView.showAnnotations([MKPlacemark(placemark: results![0])], animated: true)
                        self.mapString = self.studentLocationTextField.text!
                        self.saveButton.isEnabled = true
                        
                        // ZOOM IN ON MAP
                        
                        if let coordinates = self.placemark.location?.coordinate {
                        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        let region = MKCoordinateRegion(center: coordinates, span: span);
                        self.mapView.setRegion(region, animated: true)
                        }
                        
                        // UPDATE studentLocationTextField TO CORRECT ADDRESS FORMAT
                        
                        let studentLocation = (self.placemark.location?.coordinate)! as CLLocationCoordinate2D
                        
                        let studentLatitude: CLLocationDegrees = studentLocation.latitude
                        let studentLongitude: CLLocationDegrees = studentLocation.longitude
                        
                        let studentAddress: CLLocation =  CLLocation(latitude: studentLatitude, longitude: studentLongitude)
                        
                        geocoder.reverseGeocodeLocation(studentAddress) { (placemark, error) in
                            if error != nil {
                                performUpdatesOnMain{
                                    createAlert(self, error: Constants.errorStrings.noGeocodeResult)
                                    self.stopAnimatingActivityIndicator()
                                }} else {
                                if let place = placemark?[0] {
                                self.studentLocationTextField.text = "\(place.locality!), \(place.country!)"
                                self.stopAnimatingActivityIndicator()
                                    
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            
        }
    
    
    // SAVE BUTTON SAVES LOCATION AND MEDIA URL

    @IBAction func saveButtonPressed(_ sender: AnyObject) {

        if studentURLTextField.text == "" {
            createAlert(self, error: Constants.errorStrings.noMediaURL)
            self.studentURLTextField.becomeFirstResponder()
            return
        }
        
        if studentLocationTextField.text == "" {
            createAlert(self, error: Constants.errorStrings.noLocation)
            self.studentLocationTextField.becomeFirstResponder()
            return
        }
        
        startAnimatingActivityIndicator()

        self.mediaURL = studentURLTextField.text!
        
        UdacityClient.sharedInstance().GETtingPublicUserData() { (success, errorString) -> Void in
            
            if success {
                UdacityClient.sharedInstance().POSTingStudentLocation(self.mapString, latitude: self.latitude, longitude: self.longitude, mediaURL: self.mediaURL) { (success, errorString) -> Void in
                    
                    if success {
                        performUpdatesOnMain {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(controller!, animated: true, completion: nil)
                        self.stopAnimatingActivityIndicator()
                        print("student data post successful")
                        
                        }
                    }
                    
                    else {
                        performUpdatesOnMain {
                            createAlert(self, error: errorString!)
                            self.stopAnimatingActivityIndicator()
                        
                        }
                    }
                }
            }
            
            else {
                performUpdatesOnMain {
                    createAlert(self, error: errorString!)
                    self.stopAnimatingActivityIndicator()
                
                }
            }
        }
    }
    
        // CANCEL BUTTON REDIRECTS USER TO TAB BAR CONTROLLER
    
        @IBAction func cancelButtonPressed(_ sender: AnyObject) {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
    }
    
}

// MARK: - AddLocationViewController: UITextFieldDelegate


extension AddLocationViewController {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) 
    }
}

// MARK: - AddLocationViewController (Notifications)

private extension AddLocationViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

// ACTIVTY INDICATOR

private extension AddLocationViewController {
    
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






