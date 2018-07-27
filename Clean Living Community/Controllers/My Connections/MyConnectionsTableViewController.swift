//
//  MyConnectionsTableViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class MyConnectionsTableViewController: UITableViewController
{

    let userModel = UserModel.sharedInstance
    let currentUserID = Auth.auth().currentUser?.uid
    var connections : [String: String]?
    var connectionsSorted: [(key: String, value: String)]?
    var sortedConnectionUIDS: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel.listAllConnections(withUID: currentUserID,completion: {(list)
            in
            if (list.count >= 0)
            {
                self.connections = list
                self.connectionsSorted = (self.connections?.sorted(by: {$0.value < $1.value}))!
                self.tableView.reloadData()
                
                
            }
        })

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if(connectionsSorted != nil)
        {
            return (connectionsSorted?.count)!
        }
        else
        {
            return(0)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionscell", for: indexPath) as! ConnectionsTableViewCell

        // Configure the cell...
       
        
        cell.photo.image = UIImage(named: "No Photo.png")
        cell.datalabel.text = connectionsSorted![indexPath.row].value
        sortedConnectionUIDS.append(connectionsSorted![indexPath.row].key)
        print(sortedConnectionUIDS)
        print(connectionsSorted![indexPath.row].key)
        let tempUser = userModel.findUser(uid: connectionsSorted![indexPath.row].key)
        
        setImageFromURl(stringImageUrl: (tempUser?.url1)!, forImage: cell.photo)
        return cell
       
 
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var sentUser : User?
        print(sortedConnectionUIDS)
        for uid in sortedConnectionUIDS
        {
            if(uid == sortedConnectionUIDS[indexPath.row])
            {
                sentUser = userModel.findUser(uid: uid)
            }
        }
        
        performSegue(withIdentifier: "toFriendProfile", sender: sentUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toFriendProfile")
        {
            let destinationVC = segue.destination as! FriendProfileViewController
            destinationVC.thisUser = sender as? User
            
        }
        
    }
    
    
    
    
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
        }
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}