//
//  CoreDataHelperPerson.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/2/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelperPerson {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    //save person
    static func savePerson() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func retrievePerson() -> [Person] {
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch \(error)")
            return []
        }
    }
    
    //new person
    static func newPerson() -> Person {
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: managedContext) as! Person
        return person
    }
}
