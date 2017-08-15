//
//  ChangePasscodeViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class ChangePasscodeViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var newPasscodeTextField: UITextField!
    @IBOutlet weak var oldPasscodeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        newPasscodeTextField.layer.cornerRadius = 8
        oldPasscodeTextField.layer.cornerRadius = 8
        newPasscodeTextField.layer.borderWidth = 1.0
        oldPasscodeTextField.layer.borderWidth = 1.0
        newPasscodeTextField.layer.borderColor = mintGreen.cgColor
        oldPasscodeTextField.layer.borderColor = mintGreen.cgColor
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToSettings", sender: self)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if oldPasscodeTextField.text == person.passcode {
            if newPasscodeTextField.text != "" {
                person.passcode = newPasscodeTextField.text
                CoreDataHelperPerson.savePerson()
                performSegue(withIdentifier: "unwindToSettings", sender: self)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
