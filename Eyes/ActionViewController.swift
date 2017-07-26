//
//  ActionViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/25/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var deactivateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func alertButtonTapped(_ sender: UIButton) {
        print("alertButtonTapped")
    }
    @IBAction func deactivateButtonTapped(_ sender: UIButton) {
        print("deactivateButtonTapped")
    }
    
    @IBAction func unwindToActionView(segue:UIStoryboardSegue) { }

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
