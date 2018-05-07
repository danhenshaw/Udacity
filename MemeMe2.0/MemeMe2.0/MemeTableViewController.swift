//
//  MemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Dan Henshaw on 29/6/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView!.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
       let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
       if let detailTextLabel = cell.detailTextLabel {
        detailTextLabel.text = meme.bottomText
        }
        
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
