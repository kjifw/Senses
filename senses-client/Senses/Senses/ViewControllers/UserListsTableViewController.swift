//
//  UserListsTableViewController.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class UserListsTableViewController: UITableViewController, HttpRequesterDelegate {
    
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
    
    var items: [String] = []
    
    var party: PartyDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User parties"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "user-lists-list-cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user-lists-list-cell", for: indexPath)

        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.loadingScreenStart()
        self.http?.get(fromUrl: "\(self.url)/party/\(self.items[indexPath.row])/details")
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            self.loadingScreenStop()
            let nextVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "PartyDetailsVC") as! PartyDetailsViewController
            
            let partyDetails = data as! Dictionary<String, Any>
            
            if(partyDetails["party"] != nil) {
                let partyDict = partyDetails["party"] as! Dictionary<String, Any>
                let party = PartyDetailsModel.init(withDict: partyDict)
                nextVC.party = party
                self.show(nextVC, sender: self)
            }
        }
    }
}
