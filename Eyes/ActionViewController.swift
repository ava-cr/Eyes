//
//  ActionViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts
import MessageUI


class ActionViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var deactivateButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customization
        alertButton.layer.cornerRadius = 8
        alertButton.layer.borderColor = darkRed.cgColor
        alertButton.layer.borderWidth = 5.0
        contactButton.layer.cornerRadius = 8
        contactButton.layer.borderColor = greyBlue.cgColor
        contactButton.layer.borderWidth = 2.0
        locationButton.layer.cornerRadius = 8
        locationButton.layer.borderColor = greyBlue.cgColor
        locationButton.layer.borderWidth = 2.0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        alertButton.flash()
    }
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        print("alertButtonTapped")
        let messageViewController = MFMessageComposeViewController()
        messageViewController.body = "\(person.name)" + " has sent an ALERT, signalling a potentially dangerous situation. Please try to get in touch with " + "\(person.name)" + " immediately. This alert has been sent to every one of " + "\(person.name)" + "'s predetermined contacts."
        let numbers = Array(person.namesNumbers.values)
        print(numbers)
        messageViewController.recipients = numbers
        
        messageViewController.messageComposeDelegate = self
        messageViewController.view.tintColor = darkRed
        
        self.present(messageViewController, animated: true, completion: nil)
    }
  
    @IBAction func deactivateButtonTapped(_ sender: UIButton) {
        print("deactivateButtonTapped")
    }
    
    @IBAction func unwindToActionView(segue:UIStoryboardSegue) { }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //can put code depending on which result of the message - successful, cancel, failure ...
        controller.dismiss(animated: true, completion: nil)
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
