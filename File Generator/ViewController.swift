//
//  ViewController.swift
//  File Generator
//
//  Created by Team on 7/26/18.
//  Copyright © 2018 File Generator Team. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func launchSystemPreferences(_ sender: Any)
    {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.extensions")
        NSWorkspace.shared.open(url!)
    }
}

