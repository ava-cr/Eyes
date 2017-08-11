//
//  TextContactsTableViewController.swift
//  Eyes
//
//  Created by Ava Crnkovic-Rubsamen on 7/26/17.
//  Copyright © 2017 Ava Crnkovic-Rubsamen. All rights reserved.
//

import UIKit

class TextContactsTableViewController: UITableViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var navigationBarAppearace = UINavigationBar.appearance()
    var person = Person()
    var contacts = [Contact]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = CoreDataHelperPerson.retrievePerson()[0]
        contacts = CoreDataHelperContact.retrieveContacts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:darkRed]
        navigationBarAppearace.barTintColor = lightPink
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background2"))
        
    }
    


    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "backToCallText", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "textContactsTableViewCell", for: indexPath) as! TextContactsTableViewCell
        
        let row = indexPath.row
        let contact = contacts[row]
        
        cell.contactNameLabel.text = "\(contact.givenName ?? "") \(contact.familyName ?? "")"
        cell.backgroundColor = .clear
        let view = UIView()
        view.backgroundColor = lightPink
        cell.selectedBackgroundView = view
        
        return cell
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "contactChosen" {
                
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let contact = contacts[indexPath.row]
                // 3
                let sendTextViewController = segue.destination as! SendTextViewController
                // 4
                sendTextViewController.contact = contact
            }
        }
    }
    

}
