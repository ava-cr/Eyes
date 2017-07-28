//
//  DeactivateViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class DeactivateViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var deactivateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToActionView", sender: self)
    }
    @IBAction func deactivateButtonTapped(_ sender: Any) {
        if passcodeTextField.text == person.passcode {
            print("deactivated")
            performSegue(withIdentifier: "backToHome", sender: self)
        }
        else {
            print("not the correct passcode")
            print("correct passcode: " + "\(person.passcode)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
