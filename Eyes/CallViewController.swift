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

class CallViewController: UIViewController {
    
    var contact: CNContact?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let phoneURL = URL(string: "tel://" + person.namesNumbers[contact!.givenName]!) else { return }
        UIApplication.shared.open(phoneURL , options: [:], completionHandler: nil)

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
