//
//  CallTextViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import CoreLocation

class CallTextViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()


    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "backToAction", sender: self)
    }
    
    @IBAction func backToCallText(segue:UIStoryboardSegue) { }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
