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
        
        let cellNib = UINib(nibName: "UserListTableViewCell", bundle: nil)
        
        self.tableView.register(cellNib, forCellReuseIdentifier: "top-users-list-custom-cell")
        self.tableView.rowHeight = 124
        
        self.loadingScreenStart()
        self.http?.get(fromUrl: "\(self.url)/user/list/top")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "top-users-list-custom-cell", for: indexPath) as! UserListTableViewCell
        
        cell.city.text = self.userList[indexPath.row].city
        cell.username.text = self.userList[indexPath.row].username
        cell.kudos.text = self.userList[indexPath.row].kudos
        
        cell.cellImage.contentMode = .scaleAspectFit
        if(self.userList[indexPath.row].picture != nil && self.userList[indexPath.row].picture != "") {
            let imageData = Data(base64Encoded: (self.userList[indexPath.row].picture)!)
            cell.cellImage.image = UIImage(data: imageData! as Data)
        } else {
            cell.cellImage.image = UIImage(named: "user-image")
        }
        
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
}
