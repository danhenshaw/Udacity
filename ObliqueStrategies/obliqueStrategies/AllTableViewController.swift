//
//  TableViewController.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 7/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit

class AllTableViewController: UITableViewController {
    
    @IBOutlet var obliqueStrategyTable: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var homeButton: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadObliqueStrategies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        obliqueStrategyTable.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        obliqueStrategyTable.reloadData()
    }
    
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // LOAD OBLIQUE STRATEGY FROM WEB API
    
    func loadObliqueStrategies() {
        
        startActivityIndicator()
        
        APIRequestManager.sharedInstance().GETtingObliqueStrategies { (success, errorString) -> Void in
            performUpdatesOnMain {
                if success {
                    self.obliqueStrategyTable.reloadData()
                    self.stopActivityIndicator()
                    print("Oblique Strategies successfully downloaded from web API")
                } else {
                    performUpdatesOnMain {
                        print("Error downloading Oblique Strategies from web API")
                        self.createAlert(errorString!)
                        self.stopActivityIndicator()
                    }
                }
            }
        }
    }

    // COUNT FOR NUMBER OF ROWS

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(ObliqueStrategies.dataArray.count)
        
    }
    
    // CELL CONFIGURATION
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let obliqueStrategy = ObliqueStrategy(dictionary: ObliqueStrategies.dataArray[(indexPath as NSIndexPath).row])
        
        cell.textLabel?.text = obliqueStrategy.strategy!
        cell.detailTextLabel?.text = "Edition: \(obliqueStrategy.edition!). Card Number: \(obliqueStrategy.cardnumber!)."
        
        return cell

    }
    
    // ACTION TAP ON TABLE CELL
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obliqueStrategy = ObliqueStrategy(dictionary: ObliqueStrategies.dataArray[indexPath.row])
        APIRequestManager.sharedInstance().obliqueStrategyIDFromTableView = obliqueStrategy.id!
        
        dismiss(animated: true, completion: nil)
    }
}
