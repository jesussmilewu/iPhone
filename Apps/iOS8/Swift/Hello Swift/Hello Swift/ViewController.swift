//
//  ViewController.swift
//  Hello Swift
//
//  Created by Klaus Rodewig on 30.09.14.
//  Copyright (c) 2014 Cocaneheads. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBAction func go(sender: AnyObject) {
        let theURL = NSURL.URLWithString("http://www.rodewig.de/ip.php")
        var theIP = NSString.stringWithContentsOfURL(theURL, encoding: NSUTF8StringEncoding, error: nil)
        label.text = theIP
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Moin"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

