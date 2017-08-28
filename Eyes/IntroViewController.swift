//
//  IntroViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/27/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.layer.cornerRadius = 8
        okButton.layer.borderColor = mintGreen.cgColor
        okButton.layer.borderWidth = 1.0
        
        okButton.pulsate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
