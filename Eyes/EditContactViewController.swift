//
//  EditContactViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/3/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var contact: Contact?
    var contacts = [Contact]()
    var navigationBarAppearace = UINavigationBar.appearance()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyKeyboardPush()
        applyKeyboardDismisser()
        
        if contact == nil {
            contact = CoreDataHelperContact.newContact()
            CoreDataHelperContact.saveContact()
        }
        
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: (contact?.givenName ?? "contact's first name"), attributes: [NSForegroundColorAttributeName: mintGreen])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: (contact?.familyName ?? "contact's last name"), attributes: [NSForegroundColorAttributeName: mintGreen])
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: (contact?.phoneNumber ?? "contact's phone number"), attributes: [NSForegroundColorAttributeName: mintGreen])

        contacts = CoreDataHelperContact.retrieveContacts()
        print(contacts.count)
        
        //customization
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:darkRed]
        navigationBarAppearace.barTintColor = mintGreen
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "blurry2"))
        
        firstNameTextField.layer.cornerRadius = 8
        lastNameTextField.layer.cornerRadius = 8
        phoneNumberTextField.layer.cornerRadius = 8
        firstNameTextField.layer.borderColor = mintGreen.cgColor
        lastNameTextField.layer.borderColor = mintGreen.cgColor
        phoneNumberTextField.layer.borderColor = mintGreen.cgColor
        firstNameTextField.layer.borderWidth = 1.0
        lastNameTextField.layer.borderWidth = 1.0
        phoneNumberTextField.layer.borderWidth = 1.0

    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToEditContacts", sender: self)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        // if contact exists, update it
        let contact = self.contact ?? CoreDataHelperContact.newContact()
        if firstNameTextField.text != "" {
            contact.givenName = firstNameTextField.text
        }
        if lastNameTextField.text != "" {
            contact.familyName = lastNameTextField.text
        }
        if phoneNumberTextField.text != "" {
            contact.phoneNumber = phoneNumberTextField.text
        }
        CoreDataHelperContact.saveContact()
        
        performSegue(withIdentifier: "backToEditContacts", sender: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "blurry2"))
//            return false
//        }
//        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "blurry2"))
//        return true
//    }
    
  }
