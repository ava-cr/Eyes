//
//  CoreDataHelperContact.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/2/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelperContact {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    //save person
    static func saveContact() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(contact: Contact) {
        managedContext.delete(contact)
        saveContact()
    }
    
    static func retrieveContacts() -> [Contact] {
        
        let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch \(error)")
            return []
        }
    }
    
    //new contact
    static func newContact() -> Contact {
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: managedContext) as! Contact
        return contact
    }
}
