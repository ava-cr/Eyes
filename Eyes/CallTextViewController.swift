//
//  CallTextViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class CallTextViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var textButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        callButton.layer.cornerRadius = 8
        callButton.layer.borderWidth = 3.0
        callButton.layer.borderColor = greyBlue.cgColor
        textButton.layer.cornerRadius = 8
        textButton.layer.borderWidth = 3.0
        textButton.layer.borderColor = greyBlue.cgColor

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
