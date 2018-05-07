//
//  FavouritesTableViewController.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 8/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit
import CoreData

class FavouritesTableViewController: UITableViewController {

    @IBOutlet var favourtiesTable: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    var favouriteObliqueStrategies:[ObliqueStrategyCoreData] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavouriteObliqueStrategies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favourtiesTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        favourtiesTable.reloadData()
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // FETCH FAVOURITED OBLIQUE STRATEGIES FROM CORE DATA
    
    func loadFavouriteObliqueStrategies() {
        
        startActivityIndicator()
        
        do {
            favouriteObliqueStrategies = try context.fetch(ObliqueStrategyCoreData.fetchRequest())
            self.stopActivityIndicator()
        } catch {
            print(error)
            self.stopActivityIndicator()
        }
    }
   
    // COUNT FOR NUMBER OF ROWS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteObliqueStrategies.count
    }
    
    // CELL CONFIGURATION
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let favouriteObliqueStrategy = favouriteObliqueStrategies[indexPath.row]
        
        cell.textLabel?.text = favouriteObliqueStrategy.strategy!
        cell.detailTextLabel?.text = "Edition: \(favouriteObliqueStrategy.edition). Card Number: \(favouriteObliqueStrategy.cardnumber)."
        
        return cell
    }
    
    // ACTION TAP ON TABLE CELL
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let favouriteObliqueStrategy = favouriteObliqueStrategies[indexPath.row]
        APIRequestManager.sharedInstance().obliqueStrategyIDFromTableView = Int(favouriteObliqueStrategy.id)
        
        dismiss(animated: true, completion: nil)
    }
    
}
