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
            timer.invalidate()
            followUpTimer.invalidate()
            secondFollowUpTimer.invalidate()
            runTimer()
        default:
            print("You have checked in by opening the app!")
            timer.invalidate()
            followUpTimer.invalidate()
            secondFollowUpTimer.invalidate()
            runTimer()
        }
        
        completionHandler()
    }
    
    func followUpNotification() {
        print("follow up notification!!")
        timer.invalidate()
        runFollowUpTimer()
        configureUserNotificationCenter()
        
        
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Warning: You Haven't Checked In!"
        //content.subtitle = "From MakeAppPie.com"
        content.body = "This is the first follow-up notification, if you don't respond to the second, your contacts will be notified."
        content.categoryIdentifier = "myCategory"
        
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10.0,
            repeats: false)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "followup.message",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
        
    }
    
    func secondFollowUp() {
        
        print("second follow up notification!!")
        //timer.invalidate()
        followUpTimer.invalidate()
        runSecondFollowUpTimer()
        configureUserNotificationCenter()
        
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Warning: You Haven't Checked In!"
        //content.subtitle = "From MakeAppPie.com"
        content.body = "If you don't respond to this notification, your contacts will be notified!"
        content.categoryIdentifier = "myCategory"
        
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10.0,
            repeats: false)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "second.followup",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
    }
    
    func noResponseToFollowUps() {
        secondFollowUpTimer.invalidate()
        print("User did not respond to follow up notifications!!!")
        
        configureUserNotificationCenter()
        
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Your Contacts Are Being Notified!"
        //content.subtitle = "From MakeAppPie.com"
        content.body = "You have been unresponsive and your stuation could be potentially dangerous."
        content.categoryIdentifier = "myCategory"
        
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10.0,
            repeats: false)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "contacts.message",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
    }
    
    func runTimer() {
        print("run timer started")
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: (#selector(self.followUpNotification)), userInfo: nil, repeats: true)
    }
    func runFollowUpTimer() {
        print("follow up timer started")
        followUpTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(self.secondFollowUp)), userInfo: nil, repeats: true)
    }
    
    func runSecondFollowUpTimer() {
        print("second follow up timer started")
        secondFollowUpTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(self.noResponseToFollowUps)), userInfo: nil, repeats: true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        alertButton.flash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer.invalidate()
        followUpTimer.invalidate()
        secondFollowUpTimer.invalidate()
        
        runTimer()
        
        
        self.person = CoreDataHelperPerson.retrievePerson()[0]
        self.contacts = CoreDataHelperContact.retrieveContacts()
        
        configureUserNotificationCenter()
        
        
        
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Check in with Eyes!"
        //content.subtitle = "From MakeAppPie.com"
        content.body = "It's been half an hour, check-in or open through the notification to assure us you're ok."
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
