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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "passcodeInputted" {
                person.passcode = passcodeTextField.text ?? ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
