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

var timer = Timer()
var followUpTimer = Timer()
var secondFollowUpTimer = Timer()

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
        let actionCheckIn = UNNotificationAction(identifier: "Check-in", title: "Check-in", options: [])
        //let actionShowDetails = UNNotificationAction(identifier: "showDetails", title: "Show Details", options: [.foreground])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [actionCheckIn], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Check-in":
            print("Checked in from notification!")

            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            person.notRespondedTo = 0
            CoreDataHelperPerson.savePerson()
            sendNormalNotification()
        default:
            print("You have checked in by opening the app!")

            person.notRespondedTo = 0
            CoreDataHelperPerson.savePerson()
            sendNormalNotification()
        }
        
        completionHandler()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        alertButton.flash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        person.notRespondedTo = 0
        CoreDataHelperPerson.savePerson()
        super.viewWillAppear(true)

        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
        self.person = CoreDataHelperPerson.retrievePerson()[0]
        self.contacts = CoreDataHelperContact.retrieveContacts()
        
        sendNormalNotification()
        
    }
    
    func sendNormalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Check in with Eyes!"
        content.body = "It's been half an hour, check-in or open through the notification to assure us you're ok."
        content.categoryIdentifier = "myCategory"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10.0,
            repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "checkin.message",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
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
