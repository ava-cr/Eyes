//
//  PasscodeViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController {
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var person = Person()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "passcodeInputted" {
                person.passcode = passcodeTextField.text ?? ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]

        // Do any additional setup after loading the view.
        applyKeyboardDismisser()
        passcodeTextField.layer.cornerRadius = 8
        passcodeTextField.layer.borderColor = mintGreen.cgColor
        passcodeTextField.layer.borderWidth = 1.0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        doneButton.pulsate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
