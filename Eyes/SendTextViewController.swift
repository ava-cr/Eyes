//
//  SendTextViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI

class SendTextViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    var contact: CNContact?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.body = messageTextView.text!
        messageViewController.recipients = [person.namesNumbers[contact!.givenName]!]
        messageViewController.messageComposeDelegate = self
        messageViewController.view.tintColor = darkRed
        
        self.present(messageViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(contact!.givenName)
        print(person.namesNumbers[contact!.givenName]!)
        //HERE YOU WILL FORMULATE AND SEND THE TEXT USING THE TUTORIAL https://www.youtube.com/watch?v=tDQtAReaRwI
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //can put code depending on which result of the message - successful, cancel, failure ...
        controller.dismiss(animated: true, completion: nil)
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
