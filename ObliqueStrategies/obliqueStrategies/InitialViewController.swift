//
//  InitialViewController.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 7/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InitialViewController: UIViewController {
    
    // ADD OUTLETS
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var removeFromFavouritesButton: UIBarButtonItem!
    @IBOutlet weak var addToFavouritesButton: UIBarButtonItem!
    @IBOutlet weak var viewFavouritesButton: UIBarButtonItem!
    @IBOutlet weak var viewAllButton: UIBarButtonItem!

    
    var label = UILabel()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isAlreadyFavourited = Bool()
    var obliqueStrategyLabelText = String()
    var favouriteObliqueStrategy = ObliqueStrategyCoreData()
    var defaultLabelText = "tap screen for an Oblique Strategy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLabel()
        screenTap()
        configureLabelText()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchFavourites()
        configureNavigationBar()
        loadSpecificObliqueStrategy()
    }

    
    // ABILITY TO SHARE OBLIQUE STRATEGY IMAGE OR SHAVE TO PHOTO ALBUM
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        if obliqueStrategyLabelText == "" ||  obliqueStrategyLabelText == defaultLabelText {
            createAlert(errorStrings.noCardSelected)
        } else {
            share()
        }
    }
    
    // REMOVE OBLIQUE STRATEGY TO FAVOURITES
     
    @IBAction func removeFromFavouritesButtonPressed(_ sender: AnyObject) {
     if obliqueStrategyLabelText != defaultLabelText {
        if isAlreadyFavourited == true {
            removeFromFavourites()
        }
     } else {
        createAlert(errorStrings.noCardSelected)
        }
    }
    
    // ADD OBLIQUE STRATEGY TO FAVOURITES
    
    @IBAction func addToFavouritesButtonPressed(_ sender: AnyObject) {
        if obliqueStrategyLabelText != defaultLabelText {
            if isAlreadyFavourited == false {
                addToFavourites()
            } else {
            createAlert(errorStrings.noCardSelected)
            }
        }
    }

    // SEGUE TO THE FAVOURITES TABLE VIEW CONTROLLER

    @IBAction func viewFavouritesButtonPressed(_ sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesNavigationController")
        self.present(controller!, animated: true, completion: nil)
    }

    // SEGUE TO THE ALL TABLE VIEW CONTROLLER
    

    @IBAction func viewAllButtonPressed(_ sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllNavigationController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    // CONFIGURE NAVIGATION BAR ITEMS 
    
    func configureNavigationBar() {
        
        // DISABLE NAVIGATION ITEMS IF NO OBLIQUE STRATEGY CARD HAS BEEN SELECTED
        
        if obliqueStrategyLabelText == "" ||  obliqueStrategyLabelText == defaultLabelText {
            shareButton.isEnabled = false
            addToFavouritesButton.isEnabled = false
            removeFromFavouritesButton.isEnabled = false
        } else {
            
            // ENABLE THE SHARE BUTTON IF AN OBLIQUE STRATEGY HAS BEEN DOWNLOADED FROM WEB API
            
            shareButton.isEnabled = true
            
            // REMOVE AND ADD BUTTONS ARE ONLY ENABLED DEPENDING ON THEIR CURRENT SAVED STATUS
            
            if isAlreadyFavourited == true {
                removeFromFavouritesButton.isEnabled = true
                addToFavouritesButton.isEnabled = false
            } else if isAlreadyFavourited == false {
                addToFavouritesButton.isEnabled = true
                removeFromFavouritesButton.isEnabled = false
            }
        }
    }
    
    // ADD LABEL TO VIEW AND SETUP GENERAL LABEL ATTRIBUTES
    
    func addLabel() {
    
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.frame = CGRect(x: 15, y: 54, width: view.frame.size.width - 20, height: view.frame.size.height - 500)
        label.numberOfLines = 0
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y
        self.view.addSubview(label)
        
    }
    
    // CONFIGURE LABEL TEXT
    
    func configureLabelText() {
    
        if obliqueStrategyLabelText == "" || obliqueStrategyLabelText == defaultLabelText {
            defaultLabelTextAttributes()
        } else {
            obliqueStrategyLabelTextAttributes()
        }
    }
    
    // DEFAULT LABEL TEXT ATTRIBUTES
    
    func defaultLabelTextAttributes() {
        label.text = defaultLabelText
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "helvetica", size: 14)
    }
    
    // LABEL TEXT ATTRIBUTES FOR WHEN AN OBLIQUE STRATEGY HAS BEEN SELECTED
    
    func obliqueStrategyLabelTextAttributes() {
        label.text = obliqueStrategyLabelText
        label.textColor = UIColor.white
        label.font = UIFont(name: "helvetica", size: 18)
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.white.cgColor
    }
    
    // ADD TAP GESTURE RECOGNITION TO VIEW CONTROLLER
    
    func screenTap() {
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(loadRandomObliqueStrategy))
        self.view.addGestureRecognizer(screenTap)
    }
    
    // FUNC TO LOAD SINGLE OBLIQUE STRATEGY FROM TAP GESTURE RECOGNITION
    
    func loadRandomObliqueStrategy() {
        
        startActivityIndicator()
        
        APIRequestManager.sharedInstance().GETtingSingleObliqueStrategy { (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                    self.obliqueStrategyLabelText = ("\(APIRequestManager.sharedInstance().singleObliqueStrategyStrategy!)")
                    self.configureLabelText()
                    self.searchFavourites()
                    self.configureNavigationBar()
                    self.shareButton.isEnabled = true
                    self.stopActivityIndicator()
                    
                } else {
                    
                    performUpdatesOnMain {
                        self.createAlert(errorString!)
                        self.stopActivityIndicator()
                        
                    }
                }
            }
        }
    }

    
    // ADD OBLIQUE STARTEGY DISPLAYED ON SCREEN TO FAVOURITES IN CORE DATA

    func addToFavourites() {
        
        // FIRST CHECK TO SEE IF WE HAVE LOADED AN OBLIQUE STRATEGY PREVIOUSLY. IF NO OBLIQUE STRATEGY FOUND, UPDATE BASED ON CURRENT LABEL TEXT BEFORE SAVING
        
        if APIRequestManager.sharedInstance().singleObliqueStrategyStrategy == nil {
            loadAndSaveSpecificObliqueStrategy()
            
        } else {
            
        // CONFIRM WHETHER WE HAVE SEGUED FROM A TABLE VIEW CONTROLLER BY CHECKING LABEL TEXT WITH OBLIQUE STRATEGY FROM API REQUEST
        
        if obliqueStrategyLabelText == APIRequestManager.sharedInstance().singleObliqueStrategyStrategy {
            
            let obliqueStrategy = NSEntityDescription.insertNewObject(forEntityName: "ObliqueStrategyCoreData", into: context)
            
            let id = APIRequestManager.sharedInstance().singleObliqueStrategyID! as Int
            let edition = APIRequestManager.sharedInstance().singleObliqueStrategyEdition! as Int
            let cardnumber = APIRequestManager.sharedInstance().singleObliqueStrategyCardNumber! as Int
            let strategy = APIRequestManager.sharedInstance().singleObliqueStrategyStrategy! as String
            
            obliqueStrategy.setValue(id, forKey: "id")
            obliqueStrategy.setValue(edition, forKey: "edition")
            obliqueStrategy.setValue(cardnumber, forKey: "cardnumber")
            obliqueStrategy.setValue(strategy, forKey: "strategy")
        
        do {
            
            // SAVE OBLIQUE STRATEGY TO CORE DATA
            
            try context.save()
            
            // UPDATE THE NAVIGATION BAR TO REFLECT THAT THE CURRENT OBLIQUE STRATEGY HAS RECENTLY BEEN ADDED TO THE FAVOURITES
            
            searchFavourites()
            configureNavigationBar()
            print("Saved Oblique Strategy, '\(strategy)' to core data")
    
        } catch {
            print(error)
        }
        } else {
            
        // IF WE HAVE PREVIOUSLY LOADED AN OBLIQUE STRATEGY BUT IT IS DIFFERENT FROM THE ONE CURRENTLY DISPLAYED, UPDATE THE OBLIQUE STRATEGY AND THEN SAVE
            
            loadAndSaveSpecificObliqueStrategy()
        }
        }
    }
    
    // DOWNLOAD A SPECIFIC OBLIQUE STRATEGY FROM WEB API AND THEN SAVE TO CORE DATA USING addSpecificObliqueStrategyToFavourites(). FUNCTION IS CALLED IN addToFavourites()
    
    func loadAndSaveSpecificObliqueStrategy() {
        
        APIRequestManager.sharedInstance().GETtingSpecificObliqueStrategy { (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                    self.addSpecificObliqueStrategyToFavourites()
                } else {
                    
                    performUpdatesOnMain {
                        self.createAlert(errorString!)
                        
                    }
                }
            }
        }
    }
    
    // LOAD A SPECIFIC OBLIQUE STRATEGY WHEN DISMISSING TABLE VIEW CONTROLLER
    
    func loadSpecificObliqueStrategy() {
        
        startActivityIndicator()
        
        // ENSURE THAT AN OBLIQUE STRATEGY ID HAS BEEN PASSED FROM ONE OF THE TABLE VIEW CONTROLLERS
        
        if APIRequestManager.sharedInstance().obliqueStrategyIDFromTableView != nil {
            
        // IF YES, DOWNLOAD THE OBLIQUE STRATEGY, SEARCH TO SEE IF IT HAS BEEN FAVOURITED AND CONFIGURE TEXT/NAVIGATION BAR ITEMS
        
        APIRequestManager.sharedInstance().GETtingSpecificObliqueStrategy { (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                    self.obliqueStrategyLabelText = ("\(APIRequestManager.sharedInstance().specificObliqueStrategyStrategy!)")
                    self.configureLabelText()
                    self.searchFavourites()
                    self.configureNavigationBar()
                    self.shareButton.isEnabled = true
                    self.stopActivityIndicator()
                    
                } else {
                    
                    performUpdatesOnMain {
                        self.createAlert(errorString!)
                        self.stopActivityIndicator()
                        
                    }
                }
            }
        }
        } else {
            
        // IF NOT, LOAD THE DEFAULT LABEL TEXT SO THE USER CAN TAP THE SCREEN FOR A NEW STRATEGY
            
            self.obliqueStrategyLabelText = defaultLabelText
            self.stopActivityIndicator()
        }
    }

    // SAVE A SPECIFIC OBLIQUE STRATEGY TO CORE DATA. FUNCTION IS CALLED IN loadAndSaveSpecificObliqueStrategy()

    func addSpecificObliqueStrategyToFavourites() {
        
        let obliqueStrategy = NSEntityDescription.insertNewObject(forEntityName: "ObliqueStrategyCoreData", into: context)
        
            let id = APIRequestManager.sharedInstance().specificObliqueStrategyID! as Int
            let edition = APIRequestManager.sharedInstance().specificObliqueStrategyEdition! as Int
            let cardnumber = APIRequestManager.sharedInstance().specificObliqueStrategyCardNumber! as Int
            let strategy = APIRequestManager.sharedInstance().specificObliqueStrategyStrategy! as String
            
            obliqueStrategy.setValue(id, forKey: "id")
            obliqueStrategy.setValue(edition, forKey: "edition")
            obliqueStrategy.setValue(cardnumber, forKey: "cardnumber")
            obliqueStrategy.setValue(strategy, forKey: "strategy")
    
        do {
            
            // SAVE OBLIQUE STRATEGY TO CORE DATA
            
            try context.save()
            
            // UPDATE THE NAVIGATION BAR TO REFLECT THAT THE CURRENT OBLIQUE STRATEGY HAS RECENTLY BEEN REMOVED FROM THE FAVOURITES
            
            searchFavourites()
            configureNavigationBar()
            print("Saved Oblique Strategy, '\(strategy)' to core data")
                
        } catch {
            print(error)
                
        }
    }
    
    // REMOVE CURRENT OBLIQUE STARTEGY DISPLAYED ON SCREEN TO FAVOURITES IN CORE DATA
    
    func removeFromFavourites() {
        
        let fetchRequest: NSFetchRequest<ObliqueStrategyCoreData> = ObliqueStrategyCoreData.fetchRequest()
        let searchParameter = obliqueStrategyLabelText as? String
        var predicate = NSPredicate(format: "strategy == %@", searchParameter!)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            
            // REMOVE OBLIQUE STRATEGY TO CORE DATA
            
            try context.execute(deleteRequest)
            
            // UPDATE THE NAVIGATION BAR TO REFLECT THAT THE CURRENT OBLIQUE STRATEGY HAS RECENTLY BEEN REMOVED FROM THE FAVOURITES
            
            self.searchFavourites()
            self.configureNavigationBar()
            print("'\(searchParameter!)' has been removed from Core Data")
        } catch {
            print(error)
        }
    }
    
    // SEARCH CORE DATA TO CONFIRM IF CURRENT OBLIQUE STARTEGY DISPLAYED ON SCREEN HAS BEEN PRECIOUSLY FAVOURITED

    func searchFavourites() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ObliqueStrategyCoreData")
        let searchParameter = obliqueStrategyLabelText as? String
        
        request.predicate = NSPredicate(format: "strategy == %@", searchParameter!)
        
        do {
            
            let result = try context.fetch(request)
            if result.count > 0 {
                isAlreadyFavourited = true
                print("'\(searchParameter!)' is already favourited")
                
            } else {
                isAlreadyFavourited = false
                print("'\(searchParameter!)' is not currently a favourite")
           }
        }
        catch {
            print(error)
        }
    }
    
    // HIDE NAVIGATION BAR AND TOOLBAR
    
    func navbarAndToolbarHide(_ hide: Bool){
        navigationBar.accessibilityElementsHidden = hide
        toolbar.isHidden = hide
        shareButton.accessibilityElementsHidden = hide
        addToFavouritesButton.accessibilityElementsHidden = hide
        removeFromFavouritesButton.accessibilityElementsHidden = hide
        viewAllButton.accessibilityElementsHidden = hide
        viewFavouritesButton.accessibilityElementsHidden = hide
    }

    
    // FUNC TO SAVE/SHARE CURRENT OBLIQUE STARTEGY DISPLAYED ON SCREEN
    
    func share() {
        
        let obliqueStrategyImage = generateObliqueStrategyImage()
        let activityVC = UIActivityViewController(activityItems: [obliqueStrategyImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                
                print("Oblique startegy image saved to photo library")
                
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // GENERATE AN IMAGES BASED ON THE CURRENT OBLIQUE STARTEGY DISPLAYED ON SCREEN
    
    func generateObliqueStrategyImage() -> UIImage {
        
        navbarAndToolbarHide(true)
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let obliqueStrategyImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navbarAndToolbarHide(false)
        
        return obliqueStrategyImage!
    
    }
}
