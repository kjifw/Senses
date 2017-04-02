//
//  PartyDetailsViewController.swift
//  Senses
//
//  Created by Jeff on 3/29/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class PartyDetailsViewController: UIViewController, HttpRequesterDelegate {
    
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

    var party: PartyDetailsModel?
    
    @IBOutlet weak var partyName: UILabel!
    @IBOutlet weak var partyLocation: UILabel!
    @IBOutlet weak var partyHost: UILabel!
    @IBOutlet weak var partyStartsAt: UILabel!
    @IBOutlet weak var partyType: UILabel!
    @IBOutlet weak var partyImage: UIImageView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Party Details"
        
        self.partyName.text = self.party?.name
        self.partyLocation.text = self.party?.location
        self.partyHost.text = self.party?.host
        self.partyStartsAt.text = self.party?.startsAt
        self.partyType.text = self.party?.partyType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
        self.checkIfInvitedToParty()
    }
    
    func checkIfInvitedToParty() {
        let defaults = UserDefaults.standard
        
        self.acceptButton.isHidden = true
        self.rejectButton.isHidden = true
        
        let invitationsList = defaults.array(forKey: "invitationsList") as! [String?]
        let partyId = self.party?.uniqueId
        
        for item in invitationsList {
            if(item == partyId) {
                self.acceptButton.isHidden = false
                self.rejectButton.isHidden = false
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func acceptInvitation() {
        let defaults = UserDefaults.standard
        
        let bodyDict = [
            "partyId": self.party?.uniqueId,
            "inviteeUsername": defaults.string(forKey: "username")
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/invitations/accept",
            withBody: bodyDict,
            andHeaders: headers)
    }
    
    @IBAction func rejectInvitation() {
        let defaults = UserDefaults.standard
        
        let bodyDict = [
            "partyId": self.party?.uniqueId,
            "inviteeUsername": defaults.string(forKey: "username")
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/invitations/reject",
            withBody: bodyDict,
            andHeaders: headers)
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            
            let invitationsList = defaults.array(forKey: "invitationsList") as! [String?]
            let partyId = self.party?.uniqueId
            
            let updatedList = invitationsList.filter() { $0 != partyId}
            
            defaults.set(updatedList, forKey: "invitationsList")
            defaults.synchronize()
            
            self.loadingScreenStop()
            self.displayAlertMessage(withTitle: "Invitation to party",
                                     andMessage: "Your response was submited successfully",
                                     andHandler: {
                                        (_) in
                                        self.acceptButton.isHidden = true
                                        self.rejectButton.isHidden = true
            })
        }
    }
    
    func didRecieveError(error: HttpError) {
        DispatchQueue.main.async {
            self.loadingScreenStop()
            self.displayAlertMessage(withTitle: "Invitation to party",
                                     andMessage: "Your response resulted in error",
                                     andHandler: {
                                        (_) in
            })
        }
    }
    
    @IBAction func viewParticipants() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PartyListInformation") as! PartyInformationTableViewController
        
        nextVC.users =  self.party?.participantsList as! [String]
        self.show(nextVC, sender: self)

    }
    
    @IBAction func viewInvitees() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PartyListInformation") as! PartyInformationTableViewController
        
        nextVC.users =  self.party?.inviteesList as! [String]
        self.show(nextVC, sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
