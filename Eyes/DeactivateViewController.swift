//
//  DeactivateViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import LocalAuthentication
import UserNotifications

class DeactivateViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var person = Person()
    var successAuthenticating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
    }
    // touch ID
    
    override func viewDidAppear(_ animated: Bool) {
        self.tryAgainButton.titleLabel?.textColor = UIColor.clear
        self.tryAgainButton.layer.borderWidth = 1.0
        self.tryAgainButton.layer.cornerRadius = 15
        self.tryAgainButton.layer.borderColor = UIColor.clear.cgColor
        

        super.viewDidAppear(true)
        authenticateUser()
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        authenticateUser()
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to Deactivate!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        self.person.activated = false
                        CoreDataHelperPerson.savePerson()
                        self.present(viewController, animated: true, completion: nil)
                        
                    } else {

                        let ac = UIAlertController(title: "Enter Passcode", message: "", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                                                
                                                if let alertTextField = ac.textFields?.first, alertTextField.text != nil {
                                                    if alertTextField.text! == self.person.passcode {
                                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                                        self.person.activated = false
                                                        self.person.lastCheckInTime = nil
                                                        CoreDataHelperPerson.savePerson()
                                                        self.present(viewController, animated: true, completion: nil)
                                                    }
                                                    else { self.showLabel() }
                                                }
                                                
                        }
                        
                        let cancel = UIAlertAction(title: "Cancel",
                                                   style: UIAlertActionStyle.cancel,
                                                   handler: { (action: UIAlertAction!) in self.showLabel()})
                        
                        ac.addTextField { (textField: UITextField) in
                            textField.keyboardType = UIKeyboardType.numberPad
                            textField.placeholder = "Passcode here"
                            
                        }
                        ac.addAction(ok)
                        ac.addAction(cancel)
                        
                        //ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true, completion: nil)

                    }
                }
            }

        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            let enterPasscode = UIAlertAction(title: "Enter Passcode", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                //asking for passcode if touch id is not configured
                let ac = UIAlertController(title: "Enter Passcode", message: "", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK",
                                       style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                                        
                                        if let alertTextField = ac.textFields?.first, alertTextField.text != nil {
                                            if alertTextField.text! == self.person.passcode {
                                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                                self.person.activated = false
                                                self.person.lastCheckInTime = nil
                                                CoreDataHelperPerson.savePerson()
                                                self.present(viewController, animated: true, completion: nil)
                                            }
                                            else { self.showLabel() }
                                        }
                }
                
                let cancel = UIAlertAction(title: "Cancel",
                                           style: UIAlertActionStyle.cancel,
                                           handler: nil)
                
                ac.addTextField { (textField: UITextField) in
                    textField.keyboardType = UIKeyboardType.numberPad
                    textField.placeholder = "Passcode here"
                    
                }
                ac.addAction(ok)
                ac.addAction(cancel)
                self.present(ac, animated: true, completion: nil)
            }
            ac.addAction(enterPasscode)
            present(ac, animated: true)
        }
    }
    
    func showLabel() {
        self.tryAgainButton.layer.borderColor = darkRed.cgColor
        self.tryAgainButton.titleLabel?.textColor = darkRed
        self.tryAgainButton.pulsate()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToActionView", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
