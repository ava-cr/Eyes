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
import UserNotifications


class ActionViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var deactivateButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var person = Person()
    var contacts = [Contact]()
    var isGrantedNotificationAccess:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        contacts = CoreDataHelperContact.retrieveContacts()
        
        // local notifications
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
        }
        )
        
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
    @IBAction func testNotificationTapped(_ sender: Any) {
        if isGrantedNotificationAccess{
            //add notification code here
            let content = UNMutableNotificationContent()
            content.title = "Check in with Eyes!"
            //content.subtitle = "From Eyes"
            content.body = "It's been half an hour, slide to assure us you're ok."
            content.categoryIdentifier = "message"
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 5.0,
                repeats: false)
            let request = UNNotificationRequest(
                identifier: "10.second.message",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler: nil)
        }
    }
    
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        print("alertButtonTapped")
        let messageViewController = MFMessageComposeViewController()
        messageViewController.body = "\(String(describing: person.name)) has sent an ALERT, signalling a potentially dangerous situation. Please try to get in touch with \(String(describing: person.name)) immediately. This alert has been sent to every one of \(String(describing: person.name))'s predetermined contacts."
        
        var numbers = [String]()
        for contact in contacts {
            numbers.append(contact.phoneNumber ?? "")
        }
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
}
