//
//  SettingsViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var passcodeButton: UIButton!
    @IBOutlet weak var timeIntervalButton: UIButton!
    
    var navigationBarAppearace = UINavigationBar.appearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsButton.layer.cornerRadius = 15
        passcodeButton.layer.cornerRadius = 15
        contactsButton.layer.borderColor = mintGreen.cgColor
        passcodeButton.layer.borderColor = mintGreen.cgColor
        contactsButton.layer.borderWidth = 1.0
        passcodeButton.layer.borderWidth = 1.0
        
        timeIntervalButton.layer.cornerRadius = 15
        timeIntervalButton.layer.borderColor = mintGreen.cgColor
        timeIntervalButton.layer.borderWidth = 1.0
        

        navigationBarAppearace.barTintColor = darkGrey
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsToHome", sender: self)
    }
    
    
    @IBAction func unwindToSettings(segue:UIStoryboardSegue) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
