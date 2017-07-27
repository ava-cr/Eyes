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

var person = Person()


class InfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var chooseContactsButton: UIButton!
    var displayedKeys: [String] = ["givenName", "phoneNumbers"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "infoFinished" {
                person.name = nameTextField.text ?? ""
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func chooseContactsButtonTapped(_ sender: UIButton) {
        
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
            }
            if contact.phoneNumbers.count == 1 {
                phoneNumber = (contact.phoneNumbers[0].value).value(forKey: "digits")! as! String
            }
            person.namesNumbers[contact.givenName] = phoneNumber
            person.contacts.append(contact)
        }
        print(person.contacts.count)
        print(person.namesNumbers)
        
        // after contacts have been chosen
        contactInfoLabel.text = "If a contact has multiple numbers, Eyes will select the \"mobile\" or \"iPhone\" number. This can be modified in Settings."
//        okButton.titleLabel?.textColor = UIColor(red: 167, green: 196, blue: 194, alpha: 1)
        okButton.setTitle("Ok, thanks.", for: UIControlState.normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
