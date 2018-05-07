//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Dan Henshaw on 5/7/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//


import UIKit

class StudentListViewController: UITableViewController {
    
    // OUTLETS
    
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var pinButton: UIBarButtonItem!
    @IBOutlet var studentsTable: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cellConfig = "StudentCell"
    let studentInformation = Students.studentsArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsTable.delegate = self
        studentsTable.dataSource = self
        activityIndicator.isHidden = true
    }
    
    // LOADING STUDENT INFORMATION
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformation.count
    }
    
    // SETTING UP TABLE VIEW CONFIGURATION
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfig)!
        let student = Student(studentDictionary: Students.studentsArray[(indexPath as NSIndexPath).row])
        
        cell.textLabel?.text = "\(student.firstName!) \(student.lastName!)"
        cell.detailTextLabel?.text = student.mediaURL!
        
        return cell
    }
    
    // CLICK ON CELL TO GO TO STUDENT URL LINK
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.studentInformation[(indexPath as IndexPath).row]
        
        guard var mediaURL = student["mediaURL"] else {
            return
        }
        if (!mediaURL.contains("http://") && !mediaURL.contains("https://")){
            mediaURL = "http://\(mediaURL)" as AnyObject
        }
        UIApplication.shared.open(URL(string: mediaURL as! String)! as URL, options: [:], completionHandler: nil)
    }
    
    // PIN BUTTON REDIRECTS YOU TO THE ADD LOCATION VIEW CONTROLLER
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationTabBarController")
        present(controller!, animated: true, completion: nil)
    }
    
    // LOGOUT BUTTON

    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        UdacityClient.sharedInstance().DELETEingSession { (success, errorString) -> Void in
            self.startAnimatingActivityIndicator()
            performUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
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
    
    // REFRESH BUTTON
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        startAnimatingActivityIndicator()
        UdacityClient.sharedInstance().GETtingStudentLocations { (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                self.tableView.reloadData()
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

// ACTIVTY INDICATOR

private extension StudentListViewController {
    
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

