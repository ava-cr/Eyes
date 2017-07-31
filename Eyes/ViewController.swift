//
//  ViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/24/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

/** COLORS **/
var darkRed = UIColor(red: 139.0/255.0, green: 38.0/255.0, blue: 53.0/255.0, alpha: 1.0)
var darkBlue = UIColor(red: 0.0, green: 0.0, blue: 34.0/255.0, alpha: 1.0)
var greyBlue = UIColor(red: 36.0/255.0, green: 32.0/255.0, blue: 56.0/255.0, alpha: 1.0)
var darkGrey = UIColor(red: 94.0/255.0, green: 87.0/255.0, blue: 104.0/255.0, alpha: 1.0)
var mintGreen = UIColor(red: 167.0/255.0, green: 196.0/255.0, blue: 194.0/255.0, alpha: 1.0)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

