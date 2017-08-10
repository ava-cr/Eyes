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
    
    var navigationBarAppearace = UINavigationBar.appearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactsButton.layer.cornerRadius = 8
        self.passcodeButton.layer.cornerRadius = 8
        self.contactsButton.layer.borderColor = mintGreen.cgColor
        self.passcodeButton.layer.borderColor = mintGreen.cgColor
        self.contactsButton.layer.borderWidth = 1.0
        self.passcodeButton.layer.borderWidth = 1.0
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:darkBlue]
        navigationBarAppearace.barTintColor = mintGreen
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "blurry2"))
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsToHome", sender: self)
    }
    
    
    @IBAction func unwindToSettings(segue:UIStoryboardSegue) {
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "blurry2"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
