//
//  MenuViewController.swift
//  Senses
//
//  Created by Jeff on 3/30/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, HttpRequesterDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main menu"
        
        self.navigationItem.hidesBackButton = true
        
        let defaults = UserDefaults.standard
        
        print(defaults.string(forKey: "username")!)
        print(defaults.string(forKey: "token")!)
        print(defaults.string(forKey: "latestPartyHosted")!)
        print(defaults.array(forKey: "invitationsList")!)
        print(defaults.array(forKey: "historyList")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
    }

    @IBAction func goToInvitationsList() {
        let defaults = UserDefaults.standard
        
        let bodyDict = [
            "username": defaults.string(forKey: "username")
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/invitations", withBody: bodyDict, andHeaders: headers)
    }
    
    @IBAction func goToPartyHistoryList() {
        let defaults = UserDefaults.standard
        
        let bodyDict = [
            "username": defaults.string(forKey: "username")
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/history", withBody: bodyDict, andHeaders: headers)
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            let partiesList = data as! Dictionary<String, Any>

            self.loadingScreenStop()
            if(partiesList["partyHistory"] != nil) {
                self.createNextViewControllerAndShow(withData: partiesList, forList: "partyHistory", defaultsKey: "historyList")
                
            } else if(partiesList["invitationsList"] != nil) {
                self.createNextViewControllerAndShow(withData: partiesList, forList: "invitationsList", defaultsKey: "invitationsList")
                
            }
        }
    }
    
    private func createNextViewControllerAndShow(withData partiesList: Dictionary<String, Any>,
                                                 forList listId: String,
                                                 defaultsKey key: String) {
        
        let defaults = UserDefaults.standard
        let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "UserListsTableVC") as! UserListsTableViewController
        
        let parties = partiesList["\(listId)"] as! [String]
        nextVC.items = parties
        
        defaults.set(parties, forKey: "\(key)")
        self.show(nextVC, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnToMenuViewController(segue: UIStoryboardSegue) {
    }
 }








