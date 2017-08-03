//
//  DeactivateViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class DeactivateViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var deactivateButton: UIButton!
    
    var person = Person()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyKeyboardDismisser()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        deactivateButton.layer.cornerRadius = 8
        passcodeTextField.layer.cornerRadius = 8
        deactivateButton.layer.borderWidth = 1.0
        deactivateButton.layer.borderColor = darkGrey.cgColor

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToActionView", sender: self)
    }
    @IBAction func deactivateButtonTapped(_ sender: Any) {
        if passcodeTextField.text == person.passcode {
            print("deactivated")
            performSegue(withIdentifier: "backToHome", sender: self)
        }
        else {
            print("not the correct passcode")
            print("correct passcode: " + "\(String(describing: person.passcode))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
