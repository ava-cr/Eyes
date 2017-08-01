//
//  CallViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/27/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts
import MessageUI
import MapKit
import CoreLocation

class CallViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var shareLocationButton: UIButton!
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    
    var contact: CNContact?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        guard let phoneURL = URL(string: "tel://" + person.namesNumbers[contact!.givenName]!) else { return }
        UIApplication.shared.open(phoneURL , options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
        shareLocationButton.setTitle("Share Location with \(contact!.givenName)", for: UIControlState.normal)
    }
    
    func shareLocation(coordinate:CLLocationCoordinate2D) -> Void {
        
        guard let cachesPathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            print("Error: couldn't find the caches directory.")
            return
        }
        
        let vCardString = [
            "BEGIN:VCARD",
            "VERSION:3.0",
            "N:;\(person.name)'s Location;;;",
            "FN:\(person.name)'s Location",
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
            messageViewController.recipients = [person.namesNumbers[contact!.givenName]!]
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
    

    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //can put code depending on which result of the message - successful, cancel, failure ...
        controller.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
