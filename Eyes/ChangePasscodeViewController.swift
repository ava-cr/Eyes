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
        
        applyKeyboardDismisser()
        
        self.newPasscodeTextField.layer.cornerRadius = 8
        self.oldPasscodeTextField.layer.cornerRadius = 8
        self.newPasscodeTextField.layer.borderWidth = 1.0
        self.oldPasscodeTextField.layer.borderWidth = 1.0
        self.newPasscodeTextField.layer.borderColor = mintGreen.cgColor
        self.oldPasscodeTextField.layer.borderColor = mintGreen.cgColor
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToSettings", sender: self)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if oldPasscodeTextField.text == person.passcode {
            if newPasscodeTextField.text != "" {
                person.passcode = newPasscodeTextField.text
                performSegue(withIdentifier: "unwindToSettings", sender: self)
            }
        }
        else {
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
