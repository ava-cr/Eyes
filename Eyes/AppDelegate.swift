//
//  AppDelegate.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/24/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import UserNotifications
import LocalAuthentication
import NotificationCenter


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var person = Person()
    
    var contactStore = CNContactStore()
        
    var window: UIWindow?
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.present(alertController, animated: true, completion: nil)
    }
    
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message: message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var storyboard = UIStoryboard()
        var initialViewController = UIViewController()
        
        
        if CoreDataHelperPerson.retrievePerson().count == 0 {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        }
        if CoreDataHelperPerson.retrievePerson().count == 1 {
            let person = CoreDataHelperPerson.retrievePerson()[0]
            if person.activated == true {
                storyboard = UIStoryboard(name: "Activated", bundle: nil)
                initialViewController = storyboard.instantiateViewController(withIdentifier: "ActivatedViewController")
            }
            else {
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            }
            
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func noResponseToFollowUps() {
        print("User did not respond to follow up notifications!!!")
        
        
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if CoreDataHelperPerson.retrievePerson().count == 1 {
            
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            
            let person = CoreDataHelperPerson.retrievePerson()[0]
            if person.activated == true {
                
                
                //runTimer()
                
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                content.title = "Don't Quit Eyes!"
                //content.subtitle = "From MakeAppPie.com"
                content.body = "Eyes will continue to check in on you unless you quit the app!"
                
                //Set the trigger of the notification -- here a timer.
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 1.5,
                    repeats: false)
                
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
                
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if CoreDataHelperPerson.retrievePerson().count == 1 {
            let person = CoreDataHelperPerson.retrievePerson()[0]
            if person.activated == true {
                if Date() > NSDate(timeInterval: TimeInterval(person.timeInterval), since: person.lastCheckInTime! as Date) as Date {
                    print("more than 10 seconds since last check in")
                    authenticateUser()
                }
            }
        }
        
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
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotificationKey"), object: nil, userInfo: nil)
                        CoreDataHelperPerson.savePerson()
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    } else {
                        let ac = UIAlertController(title: "Enter Passcode", message: "", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                                                
                                                if let alertTextField = ac.textFields?.first, alertTextField.text != nil {
                                                    if alertTextField.text! == self.person.passcode {
                                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotificationKey"), object: nil, userInfo: nil)
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
                        UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true)
        }
    }
    
    func post(name aName: NSNotification.Name){}
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    //try 2 - with background fetch
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("background fetch complete!!")
        person = CoreDataHelperPerson.retrievePerson()[0]
        if person.activated == true {
            //only send follow up if it has been more than half an hour
            if Date() > NSDate(timeInterval: TimeInterval(person.timeInterval), since: person.lastCheckInTime! as Date) as Date {
                CoreDataHelperPerson.retrievePerson()[0].notRespondedTo = CoreDataHelperPerson.retrievePerson()[0].notRespondedTo + 1
                CoreDataHelperPerson.savePerson()
                sendFollowUpNotification()
            }
        }
        
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func sendFollowUpNotification() {
        
        let followUpNumber = CoreDataHelperPerson.retrievePerson()[0].notRespondedTo
        
        // first follow up
        if followUpNumber == 1 {
            print("haven't responded to 1 notification")
            let content = UNMutableNotificationContent()
            content.title = "Warning: You Haven't Checked In!"
            content.body = "This is the first follow-up notification, if you don't respond to the second, your contacts will be notified."
            //content.categoryIdentifier = "myCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 5.0,
                repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "followup.message",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler: nil)
            
            sleep(30)
        }
        // second follow up
        if followUpNumber == 2 {
            
            print("haven't responded to 2 notifications")
            
            let content = UNMutableNotificationContent()
            content.title = "Warning: You Haven't Checked In!"
            content.body = "If you don't respond to this notification, your contacts will be notified!"
            //content.categoryIdentifier = "myCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 5.0,
                repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "second.followup",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler: nil)
            
            sleep(30)
        }
        // third follow up - notifying contacts
        if followUpNumber == 3 {
            
            let content = UNMutableNotificationContent()
            content.title = "Your Contacts Are Being Notified!"
            content.body = "You have been unresponsive and your stuation is potentially dangerous."
            content.categoryIdentifier = "myCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 5.0,
                repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "contacts.message",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler: nil)
        }
    }
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Eyes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
