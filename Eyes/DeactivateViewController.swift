//
//  DeactivateViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import LocalAuthentication

class DeactivateViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var fingerprintButton: UIButton!
    @IBOutlet weak var passcodeButton: UIButton!
    
    
    var person = Person()
    var successAuthenticating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyKeyboardDismisser()
        applyKeyboardPush()
        
        fingerprintButton.layer.cornerRadius = 8
        fingerprintButton.layer.borderWidth = 1.0
        fingerprintButton.layer.borderColor = darkGrey.cgColor
        
        passcodeButton.layer.cornerRadius = 8
        passcodeButton.layer.borderWidth = 1.0
        passcodeButton.layer.borderColor = darkGrey.cgColor
        
        passcodeTextField.layer.cornerRadius = 8
        passcodeTextField.layer.borderWidth = 0.5
        passcodeTextField.layer.borderColor = darkGrey.cgColor
        passcodeTextField.attributedPlaceholder = NSAttributedString(string: "passcode here", attributes: [NSForegroundColorAttributeName: lightPink])
        
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        
        // Do any additional setup after loading the view.
    }
    // touch ID
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate Yourself to Deactivate!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "backToHome", sender: self)
                    } else {
                        //let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        //ac.addAction(UIAlertAction(title: "OK", style: .default))
                        //self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToActionView", sender: self)
    }
    
    @IBAction func fingerprintButtonTapped(_ sender: Any) {
        authenticateUser()
    }
    
    @IBAction func passcodeButtonTapped(_ sender: Any) {
        if passcodeTextField.text == person.passcode {
            print("deactivated")
            performSegue(withIdentifier: "backToHome", sender: self)
        }
        else {
            passcodeButton.shake()
            dismissKeyboard()

            passcodeTextField.text = ""
            print("not the correct passcode")
            print("correct passcode: " + "\(String(describing: person.passcode))")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
