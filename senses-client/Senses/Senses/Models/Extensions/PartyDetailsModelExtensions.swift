//
//  PartyDetailsModelExtensions.swift
//  Senses
//
//  Created by Jeff on 3/30/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import Foundation

extension PartyDetailsModel {
    convenience init(withDict item: Dictionary<String, Any>) {
        var invitees:[Any] = []
        var participants:[Any] = []
        
        if(item["inviteesList"] != nil) {
            invitees = item["inviteesList"] as! [Any]
        }
        
        if(item["participantsList"] != nil) {
            participants = item["participantsList"] as! [Any]
        }
        
        self.init(withName: item["name"] as! String,
                  Location: item["location"] as! String,
                  StartAt: item["startDateTime"] as! String,
                  withHost: item["host"] as! String,
                  withType: item["partyType"] as! String,
                  withImage: item["image"] as! String,
                  withInvitees: invitees,
                  withParticipants: participants)
    }
}
