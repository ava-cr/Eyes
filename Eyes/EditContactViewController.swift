//
//  EditContactViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/3/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var contact: Contact?
    var contacts = [Contact]()
    var navigationBarAppearace = UINavigationBar.appearance()
    var activeField: UITextField?

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        
        applyKeyboardDismisser()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        
        if contact == nil {
            contact = CoreDataHelperContact.newContact()
            CoreDataHelperContact.saveContact()
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+100)
        
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: (contact?.givenName ?? "contact's first name"), attributes: [NSForegroundColorAttributeName: mintGreen])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: (contact?.familyName ?? "contact's last name"), attributes: [NSForegroundColorAttributeName: mintGreen])
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: (contact?.phoneNumber ?? "contact's phone number"), attributes: [NSForegroundColorAttributeName: mintGreen])

        contacts = CoreDataHelperContact.retrieveContacts()
        print(contacts.count)
        
        //customization
        
        navigationBarAppearace.barTintColor = darkGrey
        
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
    
    // keyboard push with different text fields
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
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
  }
