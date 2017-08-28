//
//  EditContactsTableViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/3/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class EditContactsTableViewController: UITableViewController, UIPickerViewDelegate, CNContactPickerDelegate {
    
    var navigationBarAppearace = UINavigationBar.appearance()

    
    var person = Person()
    var contacts = [Contact]() {
        
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        contacts = CoreDataHelperContact.retrieveContacts()
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:darkBlue]
        navigationBarAppearace.barTintColor = darkGrey
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToSettings", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editContactsTableViewCell", for: indexPath) as! EditContactsTableViewCell
        
        let row = indexPath.row
        let contact = contacts[row]
        
        cell.contactNameLabel.text = "\(contact.givenName ?? "") \(contact.familyName ?? "")"
        cell.backgroundColor = .clear
        let view = UIView()
        view.backgroundColor = mintGreen
        cell.selectedBackgroundView = view
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //1
            CoreDataHelperContact.delete(contact: contacts[indexPath.row])
            //2
            contacts = CoreDataHelperContact.retrieveContacts()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.delegate = self
        contactPickerViewController.view.tintColor = darkBlue
        
        present(contactPickerViewController, animated: true, completion: nil)
        
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        var phoneNumber = ""
        
        for contact in contacts {
            if contact.phoneNumbers.count > 1 {
                for number in contact.phoneNumbers {
                    if number.label == "_$!<Mobile>!$_" || number.label == "_$!<iPhone>!$_" {
                        phoneNumber = (number.value).value(forKey: "digits")! as! String
                        break
                    }
                }
                if phoneNumber == "" {
                    for number in contact.phoneNumbers {
                        if number.label == "_$!<Other>!$_" || number.label == "_$!<Work>!$_" {
                            phoneNumber = (number.value).value(forKey: "digits")! as! String
                            break
                        }
                    }
                }
            }
            if contact.phoneNumbers.count == 1 {
                phoneNumber = (contact.phoneNumbers[0].value).value(forKey: "digits")! as! String
            }
            let currentContact = CoreDataHelperContact.newContact()
            currentContact.givenName = contact.givenName
            currentContact.phoneNumber = phoneNumber
            currentContact.familyName = contact.familyName
            CoreDataHelperContact.saveContact()
            self.contacts.append(currentContact)
            
        }
    }

    
    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "contactChosen" {
                
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let contact = contacts[indexPath.row]
                // 3
                let editContactViewController = segue.destination as! EditContactViewController
                // 4
                editContactViewController.contact = contact
            }
        }
    }
    
    //unwind seque
    
    @IBAction func backToEditContacts(segue:UIStoryboardSegue) {
        tableView.reloadData()
        self.contacts = CoreDataHelperContact.retrieveContacts()
    }
}
