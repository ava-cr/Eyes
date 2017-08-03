//
//  SendTextViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
import MapKit
import CoreLocation

class SendTextViewController: UIViewController, MFMessageComposeViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var shareLocationButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var textPickerView: UIPickerView!
    @IBOutlet weak var sendButton: UIButton!
    
    var person = Person()
    var contact: Contact?

    
    var textSelected = ""
    let textPickerData = ["Alert Message", "I'm safe.", "I'm okay.", "I feel unsafe.", "I'm going home now.", "Come get me please"]
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        
        applyKeyboardDismisser()
        applyKeyboardPush()

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        textPickerView.delegate = self
        textPickerView.dataSource = self
        messageTextView.delegate = self
        
        //customized button
        shareLocationButton.layer.cornerRadius = 8
        messageTextView.layer.cornerRadius = 8
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
        sendButton.layer.cornerRadius = 8
        sendButton.layer.borderColor = mintGreen.cgColor
        sendButton.layer.borderWidth = 1.0
        shareLocationButton.layer.cornerRadius = 8
        shareLocationButton.layer.borderColor = mintGreen.cgColor
        shareLocationButton.layer.borderWidth = 1.0
        
        messageTextView.layer.cornerRadius = 8
        messageTextView.layer.borderColor = mintGreen.cgColor
        messageTextView.layer.borderWidth = 1.0
        
    }
    
    
    
    func shareLocation(coordinate:CLLocationCoordinate2D) -> Void {
        
        guard let cachesPathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            print("Error: couldn't find the caches directory.")
            return
        }
        
        let vCardString = [
            "BEGIN:VCARD",
            "VERSION:3.0",
            "N:;\(person.name!)'s Location;;;",
            "FN:\(person.name!)'s Location",
            "item1.URL;type=pref:http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)",
            "item1.X-ABLabel:map url",
            "END:VCARD"
            ].joined(separator: "\n")
        
        let vCardFilePath = (cachesPathString as NSString).appendingPathComponent("vCard.loc.vcf")
        
        do {
            try vCardString.write(toFile: vCardFilePath, atomically: true, encoding: String.Encoding.utf8)
            let messageViewController = MFMessageComposeViewController()
            let url = URL(fileURLWithPath: vCardFilePath)
            messageViewController.addAttachmentURL(url, withAlternateFilename: nil)
            messageViewController.recipients = [(contact?.phoneNumber)!]
            messageViewController.messageComposeDelegate = self
            messageViewController.view.tintColor = darkRed
            
            self.present(messageViewController, animated: true, completion: nil)
            
        } catch let error {
            print("Error, \(error), saving vCard: \(vCardString) to file path: \(vCardFilePath).")
        }
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareLocation(coordinate: userLocation)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        let messageViewController = MFMessageComposeViewController()
        if messageTextView.text == "" {
            if textSelected == "Alert Message" || textSelected == "" {
                messageViewController.body = "\(person.name!)" + " has sent an ALERT, signalling a potentially dangerous situation. Please try to get in touch with " + "\(person.name!)" + " immediately. This alert has been sent to every one of " + "\(person.name!)" + "'s predetermined contacts."
            }
            else {
                messageViewController.body = textSelected
            }
        }
        else {
            messageViewController.body = messageTextView.text!
        }
        messageViewController.recipients = [(contact?.phoneNumber)!]
        messageViewController.messageComposeDelegate = self
        messageViewController.view.tintColor = darkRed
        
        self.present(messageViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
        shareLocationButton.setTitle("Share Location with \(person.name!)", for: UIControlState.normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //can put code depending on which result of the message - successful, cancel, failure ...
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //pickerView functions:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
    }
    
    // the number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return textPickerData.count
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return textPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 30)
            pickerLabel?.adjustsFontSizeToFitWidth = true
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = textPickerData[row]
        pickerLabel?.textColor = mintGreen
        
        return pickerLabel!
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("text selected: " + "\(textPickerData[row])")
        textSelected = textPickerData[row]
    }
    
    //to dismiss keyboard on return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
            return false
        }
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
        return true
    }
}
