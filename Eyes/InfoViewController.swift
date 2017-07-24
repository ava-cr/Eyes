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
    
    @IBOutlet weak var chooseContactsButton: UIButton!
    var displayedKeys: [String] = ["givenName", "phoneNumbers"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func chooseContactsButtonTapped(_ sender: UIButton) {
        
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.delegate = self
        
        present(contactPickerViewController, animated: true, completion: nil)
        
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
        
        
        
        
        
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var phoneNumber: Any

        for contact in contacts {
            
            if contact.phoneNumbers.count > 1 {
                for number in contact.phoneNumbers {
                    if number.identifier == "mobile" {
                        phoneNumber = (number.value).value(forKey: "digits")
                        print(phoneNumber)
                        break
                    }
                }
            }
            else {
                phoneNumber = (contact.phoneNumbers[0].value).value(forKey: "digits")
                print("hi")
                print(phoneNumber)
            }
            
            //let phoneNumber = (contact.phoneNumbers[0].value).value(forKey: "digits")
            print(contact.givenName)
            
        }
    }
    
    //     func contactPicker(_ picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {
    //        for contactProperty in contactProperties {
    //            if contactProperty.key == "phoneNumbers" {
    //                print("HI")
    //                print(contactProperty.contact.givenName)
    //            }
    //        }
    //    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
