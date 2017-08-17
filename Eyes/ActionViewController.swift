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
import LocalAuthentication
import NotificationCenter


var timer = Timer()
var followUpTimer = Timer()
var secondFollowUpTimer = Timer()

class ActionViewController: UIViewController, MFMessageComposeViewControllerDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var lastCheckInLabel: UILabel!
    @IBOutlet weak var deactivateButton: UIButton!
    

    
    var person = Person()
    var contacts = [Contact]()
    var isGrantedNotificationAccess:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "myNotificationKey"), object: nil)
        
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        contacts = CoreDataHelperContact.retrieveContacts()
        
        if person.lastCheckInTime != nil {
            lastCheckInLabel.text = person.lastCheckInTime?.convertToString()
        }
        
        
        //customization
        alertButton.layer.cornerRadius = 150
        alertButton.layer.borderColor = darkRed.cgColor
        alertButton.layer.borderWidth = 7.0
        lastCheckInLabel.text = (person.lastCheckInTime)?.convertToString()
        
        alertButton.titleLabel?.layer.shadowColor = darkRed.cgColor
        alertButton.titleLabel?.layer.shadowRadius = 4
        alertButton.titleLabel?.layer.shadowOpacity = 0.5
        alertButton.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        alertButton.titleLabel?.layer.masksToBounds = false
        
        
        contactButton.layer.cornerRadius = 15
        contactButton.layer.borderColor = greyBlue.cgColor
        contactButton.layer.borderWidth = 2.0
        deactivateButton.layer.cornerRadius = 15
        deactivateButton.layer.borderColor = greyBlue.cgColor
        deactivateButton.layer.borderWidth = 2.0
        
        authenticateUser()

        
    }
    
    func notificationReceived(_ notification: Notification) {
        print("user authenticated")
        self.person.notRespondedTo = 0
        self.resetCheckInLabel()
        self.sendNormalNotification()
    }
    
    func resetCheckInLabel() {
        self.lastCheckInLabel.text = (Date() as NSDate).convertToString()
        self.person.lastCheckInTime = Date() as NSDate
        CoreDataHelperPerson.savePerson()
    }
    
    func configureUserNotificationCenter() {
        let actionCheckIn = UNNotificationAction(identifier: "Check-in", title: "Check-in", options: [])
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

            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            person.notRespondedTo = 0
            CoreDataHelperPerson.savePerson()
            sendNormalNotification()
        }
        completionHandler()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        alertButton.flash()

        if person.lastCheckInTime != nil {
            if Date() > NSDate(timeInterval: TimeInterval(person.timeInterval), since: person.lastCheckInTime! as Date) as Date {
                authenticateUser()
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //authenticateUser()
        person.notRespondedTo = 0
        CoreDataHelperPerson.savePerson()
        super.viewWillAppear(true)

        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
        self.person = CoreDataHelperPerson.retrievePerson()[0]
        self.contacts = CoreDataHelperContact.retrieveContacts()
        
        //sendNormalNotification()
        
    }
    
    func sendNormalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Check in with Eyes!"
        content.body = "It's been half an hour, open the app to assure us you're ok."
        //content.categoryIdentifier = "myCategory"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1800.0,
            repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "checkin.message",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
    }
    
    func authenticateUser() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Check in!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.resetCheckInLabel()
                        self.person.notRespondedTo = 0
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        self.sendNormalNotification()

                    } else {
                        let ac = UIAlertController(title: "Enter Passcode", message: "", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                                                
                                                if let alertTextField = ac.textFields?.first, alertTextField.text != nil {
                                                    if alertTextField.text! == self.person.passcode {
                                                        self.resetCheckInLabel()
                                                        self.person.notRespondedTo = 0
                                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                                        self.sendNormalNotification()
                                                    }
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
                                                self.resetCheckInLabel()
                                                self.person.notRespondedTo = 0
                                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                                self.sendNormalNotification()
                                            }
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
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        print("alertButtonTapped")
        let messageViewController = MFMessageComposeViewController()
        messageViewController.body = "\(self.person.name ?? "The User") has sent an ALERT, signalling a potentially dangerous situation. Please try to get in touch with \(self.person.name ?? "The User") immediately. This alert has been sent to every one of \(self.person.name ?? "The User")'s predetermined contacts."
        
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
