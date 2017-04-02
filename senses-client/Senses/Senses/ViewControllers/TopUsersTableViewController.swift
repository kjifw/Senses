//
//  TopUsersTableViewController.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class TopUsersTableViewController: UITableViewController, HttpRequesterDelegate {

    var url: String {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.baseUrl
        }
    }
    
    var http: HttpRequester? {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    var userList: [UserListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Top users"

        self.http?.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "top-user-list-cell")
        
        self.loadingScreenStart()
        self.http?.get(fromUrl: "\(self.url)/user/list/top")
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "top-user-list-cell", for: indexPath)

        cell.textLabel?.text = self.userList[indexPath.row].username

        return cell
    }
 
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            let listOfUsers = data as! Dictionary<String, Any>
            if(listOfUsers["users"] != nil) {
                let userDictArr = listOfUsers["users"] as! [Dictionary<String, Any>]
                
                userDictArr.forEach({ (item) in
                    self.userList.append(UserListModel.init(withDict: item))
                })
            }
            
            self.tableView.reloadData()
            self.loadingScreenStop()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsViewController
        
        nextVC.userUsername = self.userList[indexPath.row].username
        self.show(nextVC, sender: self)
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
