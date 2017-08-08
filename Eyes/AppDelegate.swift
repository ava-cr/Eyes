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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //print("hi")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if CoreDataHelperPerson.retrievePerson().count == 1 {
            let person = CoreDataHelperPerson.retrievePerson()[0]
            if person.activated == true {
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
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("hi")
    }
    

    
    
    //        if ( application.applicationState == UIApplicationState.active)
    //        {
    //            print("Active")
    //            // App is foreground and notification is recieved,
    //            // Show a alert.
    //        }
    //        else if( application.applicationState == UIApplicationState.background)
    //        {
    //            print("Background")
    //            // App is in background and notification is received,
    //            // You can fetch required data here don't do anything with UI.
    //        }
    //        else if( application.applicationState == UIApplicationState.inactive)
    //        {
    //            print("Inactive")
    //            // App came in foreground by used clicking on notification,
    //            // Use userinfo for redirecting to specific view controller.
    //            self.redirectToPage(notification.userInfo)
    //        }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    //     func scheduleNotification(at date: Date) {
    //        let calendar = Calendar(identifier: .gregorian)
    //        let components = calendar.dateComponents(in: .current, from: date)
    //        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
    //
    //        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
    //
    //        let content = UNMutableNotificationContent()
    //        content.title = "Tutorial Reminder"
    //        content.body = "Just a reminder to read your tutorial over at appcoda.com!"
    //        content.sound = UNNotificationSound.default()
    //        content.categoryIdentifier = "myCategory"
    //
    //        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
    //            let url = URL(fileURLWithPath: path)
    //
    //            do {
    //                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
    //                content.attachments = [attachment]
    //            } catch {
    //                print("The attachment was not loaded.")
    //            }
    //        }
    //
    //        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
    //
    //        UNUserNotificationCenter.current().delegate = self
    //        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    //        UNUserNotificationCenter.current().add(request) {(error) in
    //            if let error = error {
    //                print("Uh oh! We had an error: \(error)")
    //            }
    //        }
    //    }
    
    
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
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        if response.actionIdentifier == "remindLater" {
//            let newDate = Date(timeInterval: 900, since: Date())
//            scheduleNotification(at: newDate)
//        }
//    }
//}
