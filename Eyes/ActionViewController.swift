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


class ActionViewController: UIViewController, MFMessageComposeViewControllerDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var deactivateButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    
    var person = Person()
    var contacts = [Contact]()
    var isGrantedNotificationAccess:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        contacts = CoreDataHelperContact.retrieveContacts()
        
        configureUserNotificationCenter()
        
        
        
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Check in with Eyes!"
        //content.subtitle = "From MakeAppPie.com"
        content.body = "It's been half an hour, tap to assure us you're ok."
        content.categoryIdentifier = "myCategory"
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 60.0,
            repeats: true)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "10.second.message",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error \(error)")
                // Something went wrong
            }
        })
        
        
        
        
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
        checkInButton.layer.cornerRadius = 8
        checkInButton.layer.borderColor = greyBlue.cgColor
        checkInButton.layer.borderWidth = 2.0
        checkInButton.isHighlighted = true
        checkInButton.layer.backgroundColor = UIColor(red: 139.0/255.0, green: 38.0/255.0, blue: 53.0/255.0, alpha: 0.2).cgColor
        checkInButton.isEnabled = false
    }
    
    func configureUserNotificationCenter() {
        let actionCheckIn = UNNotificationAction(identifier: "checkIn", title: "Check-in", options: [])
        let actionShowDetails = UNNotificationAction(identifier: "showDetails", title: "Show Details", options: [.foreground])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [actionCheckIn, actionShowDetails], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "checkIn":
            print("Save Tutorial For Later")
        case "showDetails":
            print("Unsubscribe Reader")
        default:
            print("Other Action")
        }
        
        completionHandler()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        alertButton.flash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.person = CoreDataHelperPerson.retrievePerson()[0]
        self.contacts = CoreDataHelperContact.retrieveContacts()
        
        let action = UNNotificationAction(identifier: "remindMeLater", title: "Check-in", options: [])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Check in with Eyes!"
        //content.subtitle = "From MakeAppPie.com"
        content.body = "It's been half an hour, slide to assure us you're ok."
        content.categoryIdentifier = "myCategory"

        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 60.0,
            repeats: true)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "checkin.message",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
        
        
    }
    
    func listNotifications() -> Void {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
            for request in requests{
                print(request.identifier)
            }
        })
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
