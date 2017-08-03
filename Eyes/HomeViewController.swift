//
//  HomeViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        
        activateButton.isUserInteractionEnabled = true
        activateButton.isEnabled = true


        //customization
        activateButton.layer.cornerRadius = 8
        activateButton.layer.borderWidth = 3.0
        activateButton.layer.borderColor = darkBlue.cgColor
        settingsButton.layer.cornerRadius = 8
        settingsButton.layer.borderWidth = 3.0
        settingsButton.layer.borderColor = lightGrey.cgColor
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activateButton.pulsate()
    }
    
    @IBAction func activateButtonTapped(_ sender: UIButton) {
        print("activateButtonTapped")
        activateButton.layer.removeAllAnimations()
        person.activated = true
        CoreDataHelperPerson.savePerson()
        
    }
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//animations

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.97
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
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
