//
//  ChangeTimeIntervalViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/15/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class ChangeTimeIntervalViewController: UIViewController {
    
    @IBOutlet weak var newIntervalTextField: UITextField!
    
    var person = Person()
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyKeyboardDismisser()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        
        newIntervalTextField.layer.cornerRadius = 8
        newIntervalTextField.layer.borderColor = mintGreen.cgColor
        newIntervalTextField.layer.borderWidth = 1.0
        
        let minutesInterval = person.timeInterval/60
        timeIntervalLabel.text = "\(minutesInterval)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToSettings", sender: self)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if newIntervalTextField.text != "" {
            let newTimeInterval = Int16(self.newIntervalTextField.text!)
            person.timeInterval = Int16(newTimeInterval! * 60)
            CoreDataHelperPerson.savePerson()
            performSegue(withIdentifier: "backToSettings", sender: self)
        }
    }
}
