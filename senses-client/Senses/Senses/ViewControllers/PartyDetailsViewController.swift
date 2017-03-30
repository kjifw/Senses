//
//  PartyDetailsViewController.swift
//  Senses
//
//  Created by Jeff on 3/29/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class PartyDetailsViewController: UIViewController {

    var party: PartyDetailsModel?
    
    @IBOutlet weak var partyName: UILabel!
    @IBOutlet weak var partyLocation: UILabel!
    @IBOutlet weak var partyHost: UILabel!
    @IBOutlet weak var partyStartsAt: UILabel!
    @IBOutlet weak var partyType: UILabel!
    @IBOutlet weak var partyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Party Details"
        
        self.partyName.text = self.party?.name
        self.partyLocation.text = self.party?.location
        self.partyHost.text = self.party?.host
        self.partyStartsAt.text = self.party?.startsAt
        self.partyType.text = self.party?.partyType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewParticipants() {
    }
    
    @IBAction func viewInvitees() {
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
