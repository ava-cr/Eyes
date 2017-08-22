//
//  InfoViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/24/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts



class InfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    var contacts = [Contact]()
    var person = Person()

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var chooseContactsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyKeyboardDismisser()
        
        
        person = CoreDataHelperPerson.newPerson()
        person.timeInterval = 1800
        CoreDataHelperPerson.savePerson()
        
        
        //customization
        chooseContactsButton.layer.cornerRadius = 8
        chooseContactsButton.layer.borderColor = mintGreen.cgColor
        chooseContactsButton.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderColor = mintGreen.cgColor
        nameTextField.layer.borderWidth = 1.0
        
        logo.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "infoFinished" {
                person.name = nameTextField.text ?? ""
                person.activated = false
                CoreDataHelperPerson.savePerson()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //animations
        if CoreDataHelperContact.retrieveContacts().count == 0 {
            chooseContactsButton.pulsate()
        }
        else {
            okButton.pulsate()
        }  
    }
    
    @IBAction func chooseContactsButtonTapped(_ sender: UIButton) {
        
        chooseContactsButton.layer.removeAllAnimations()
        
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.delegate = self
        contactPickerViewController.view.tintColor = mintGreen
        
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
            print(currentContact.givenName!)
            print(currentContact.phoneNumber!)
        }
        print(contacts.count)
        
        // after contacts have been chosen
        contactInfoLabel.text = "If a contact has multiple numbers, Eyes will select the \"mobile\" or \"iPhone\" number. This can be modified in Settings."
        okButton.setTitle("Ok, thanks.", for: UIControlState.normal)
        okButton.layer.cornerRadius = 8
        okButton.layer.borderWidth = 1.0
        okButton.layer.borderColor = mintGreen.cgColor
        logo.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
