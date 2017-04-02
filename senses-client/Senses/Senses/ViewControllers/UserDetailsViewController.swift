//
//  UserDetailsViewController.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, HttpRequesterDelegate {
    
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
    
    var userUsername: String?
    
    private var isKudosRequest = false
    private var isInviteRequest = false
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var kudos: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var genderPreferences: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var addKudosButton: UIButton!
    @IBOutlet weak var inviteToPartyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User details"
        
        self.http?.delegate = self
        
        let bodyDict = [
            "requiredUsername": self.userUsername!
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/profile", withBody: bodyDict, andHeaders: headers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let yourUsername = defaults.string(forKey: "username")
        let currentProfileUsername = self.userUsername
        
        self.isKudosRequest = false
        self.isInviteRequest = false
        
        self.addKudosButton.isHidden = true
        self.inviteToPartyButton.isHidden = true
        
        if(yourUsername != currentProfileUsername) {
            self.addKudosButton.isHidden = false
            
            let latestPartyId = defaults.string(forKey: "latestPartyHosted")
            if(latestPartyId != nil && latestPartyId != "") {
                self.inviteToPartyButton.isHidden = false
            }
        }
    }

    @IBAction func addKudos() {
        self.isKudosRequest = true
        self.isInviteRequest = false
        self.loadingScreenStart()
        
        let bodyDict = [
            "username": self.username.text,
            "kudos": "1"
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.put(toUrl: "\(self.url)/user/profile/kudos", withBody: bodyDict, andHeaders: headers)
    }
    
    @IBAction func inviteToParty() {
        self.isInviteRequest = true
        self.isKudosRequest = false
        
        let defaults = UserDefaults.standard
        
        let bodyDict = [
            "inviteeUsername": self.username.text,
            "partyId": defaults.string(forKey: "latestPartyHosted")
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/invitations/create", withBody: bodyDict, andHeaders: headers)
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            if(self.isKudosRequest == false && self.isInviteRequest == false) {
                let userInformation = data as! Dictionary<String, Any>
                let userModel = UserDetailsModel.init(withDict: userInformation)
                var allPrefs = ""
                
                self.username.text = userModel.username
                self.city.text = userModel.city
                self.age.text = userModel.age
                self.gender.text = userModel.gender
                self.kudos.text = userModel.kudos
                
                userModel.genderPrefs?.forEach({ (item) in
                    allPrefs += "\(item)"
                })
                
                self.genderPreferences.text = allPrefs
                self.about.text = userModel.about
                
                if(userModel.picture != nil && userModel.picture != "") {
                    let imageData = Data(base64Encoded: (userModel.picture)!)
                    self.image.image = UIImage(data: imageData! as Data)
                } else {
                    self.image.image = UIImage(named: "user-image")
                }
                
                self.loadingScreenStop()
            } else if(self.isKudosRequest == true && self.isInviteRequest == false) {
                self.loadingScreenStop()
                self.displayAlertMessage(withTitle: "Kudos", andMessage: "Kudos added successfully", andHandler: {
                    (_) in
                    self.performSegue(withIdentifier: "unwindFromUserDetailsToMenu", sender: self)
                })
            } else if(self.isKudosRequest == false && self.isInviteRequest == true) {
                self.loadingScreenStop()
                self.displayAlertMessage(withTitle: "Invite", andMessage: "User invited successfully to party", andHandler: {
                    (_) in
                    self.performSegue(withIdentifier: "unwindFromUserDetailsToMenu", sender: self)
                })
            }
        }
    }
    
    func didRecieveError(error: HttpError) {
        DispatchQueue.main.async {
            if(self.isKudosRequest == false && self.isInviteRequest == true) {
                self.loadingScreenStop()
                self.displayAlertMessage(withTitle: "Invite", andMessage: "User is already in the party", andHandler: {
                    (_) in
                    self.performSegue(withIdentifier: "unwindFromUserDetailsToMenu", sender: self)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
