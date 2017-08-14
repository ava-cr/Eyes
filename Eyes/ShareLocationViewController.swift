//
//  ShareLocationViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/14/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
import MapKit
import CoreLocation

class ShareLocationViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var contactLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    var person = Person()
    var contact: Contact?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.layer.borderColor = darkRed.cgColor
        shareButton.layer.borderWidth = 3.0
        shareButton.layer.cornerRadius = 15
        
        self.mapView.tintColor = darkRed
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func shareLocation(coordinate:CLLocationCoordinate2D) -> Void {
        
        guard let cachesPathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            print("Error: couldn't find the caches directory.")
            return
        }
        
        let vCardString = [
            "BEGIN:VCARD",
            "VERSION:3.0",
            "N:;\(self.person.name ?? "The User")'s Location;;;",
            "FN:\(self.person.name ?? "The User")'s Location",
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //can put code depending on which result of the message - successful, cancel, failure ...
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareLocation(coordinate: userLocation)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        contactLabel.text = ("with \((contact?.givenName) ?? "this contact")")
    }
}
