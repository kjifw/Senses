//
//  PartyInformationTableViewController.swift
//  Senses
//
//  Created by Jeff on 3/31/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class PartyInformationTableViewController: UITableViewController {

    var users: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users list"

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "party-user-list-cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "party-user-list-cell", for: indexPath)

        cell.textLabel?.text = users[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsViewController
        
        nextVC.userUsername = self.users[indexPath.row]
        self.show(nextVC, sender: self)
    }
}
