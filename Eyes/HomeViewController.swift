//
//  HomeViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter

class HomeViewController: UIViewController {
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "notActivatedKey"), object: nil)
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        person.lastCheckInTime = nil
        CoreDataHelperPerson.savePerson()
        
        
        activateButton.isUserInteractionEnabled = true
        activateButton.isEnabled = true
        
        person.activated = false
        CoreDataHelperPerson.savePerson()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func notificationReceived(_ notification: Notification) {
        activateButton.pulsate()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activateButton.pulsate()
    }
    
    
    @IBAction func activateButtonTapped(_ sender: UIButton) {
        self.person.activated = true
        CoreDataHelperPerson.savePerson()
    }
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//animations

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.2
        pulse.damping = 0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .infinity
        
        layer.add(flash, forKey: nil)
    }

    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 3
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
