//
//  MemeDetailViewController.swift
//  MemeMe1.0
//
//  Created by Dan Henshaw on 29/6/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var imageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = self.meme.memedImage
    }
}

