//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Milad Nozari on 3/10/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func record(_ sender: UIButton) {
        recordLabel.text = "Recording..."
        recordButton.isEnabled = false
        stopButton.isEnabled = true
    }

    @IBAction func stop(_ sender: UIButton) {
        recordLabel.text = "Tap to Record"
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
}

