//
//  PartyListTableViewController.swift
//  Senses
//
//  Created by Jeff on 3/27/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class PartyListTableViewController: UITableViewController, HttpRequesterDelegate {
    
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
    
    var parties: [PartyDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Parties list"
        
        self.loadingScreenStart()
        
        let cellNib = UINib(nibName: "PartyListTableViewCell", bundle: nil)
        
        self.tableView.register(cellNib, forCellReuseIdentifier: "party-list-custom-cell")
        self.tableView.rowHeight = 100
        
        self.http?.delegate = self
        
        self.http?.get(fromUrl: "\(self.url)/party/list/closest")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            let partiesList = data as! Dictionary<String, Any>
            if (partiesList["parties"] != nil) {
                let partiesDictArr = partiesList["parties"] as! [Dictionary<String, Any>]
            
                partiesDictArr.forEach({ item in
                    self.parties.append(PartyDetailsModel.init(withDict: item))
                })
            }
            
            self.tableView.reloadData()
            self.loadingScreenStop()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parties.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "party-list-custom-cell", for: indexPath) as! PartyListTableViewCell

        cell.host.text = self.parties[indexPath.row].host
        cell.location.text = self.parties[indexPath.row].location
        
        cell.cellImage.contentMode = .scaleAspectFit
        if(self.parties[indexPath.row].image != nil && self.parties[indexPath.row].image != "") {
            let imageData = Data(base64Encoded: (self.parties[indexPath.row].image)!)
            cell.cellImage.image = UIImage(data: imageData! as Data)
        } else {
            cell.cellImage.image = UIImage(named: "party-image")
        }

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PartyDetailsVC") as! PartyDetailsViewController
        
        nextVC.party = self.parties[indexPath.row]
        self.show(nextVC, sender: self)
    }
}
