//
//  ShareLocationTableViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 8/14/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class ShareLocationTableViewController: UITableViewController {
    
    var navigationBarAppearace = UINavigationBar.appearance()
    var person = Person()
    var contacts = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        contacts = CoreDataHelperContact.retrieveContacts()
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:lightGrey]
        navigationBarAppearace.barTintColor = darkRed
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareLocationTableViewCell", for: indexPath) as! ShareLocationTableViewCell
        
        let row = indexPath.row
        let contact = contacts[row]
        
        cell.contactNameLabel.text = "\(contact.givenName ?? "") \(contact.familyName ?? "")"
        cell.backgroundColor = .clear
        let view = UIView()
        view.backgroundColor = darkRed
        cell.selectedBackgroundView = view


        return cell
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMapView", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

/*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "contactChosen" {
                
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let contact = contacts[indexPath.row]
                // 3
                let locationViewController = segue.destination as! ShareLocationViewController
                // 4
                locationViewController.contact = contact
            }
        }
    }
    

}
