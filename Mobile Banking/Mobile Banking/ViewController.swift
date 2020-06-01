//
//  ViewController.swift
//  Mobile Banking
//
//  Created by Shanjinur Islam on 6/1/20.
//  Copyright © 2020 Shanjinur Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
    }
}

