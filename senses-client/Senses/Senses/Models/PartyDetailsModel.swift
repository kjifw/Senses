//
//  PartyDetailsModel.swift
//  Senses
//
//  Created by Jeff on 3/30/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import Foundation

class PartyDetailsModel{
    var name: String?
    var uniqueId: String?
    var location: String?
    var startsAt: String?
    var host: String?
    var partyType: String?
    var image: String?
    var inviteesList: [Any]?
    var participantsList: [Any]?
    
    init(withName name: String,
         id partyId: String,
         Location location: String,
         StartAt starts: String,
         withHost host: String,
         withType type: String,
         withImage image: String,
         withInvitees invitees: [Any],
         withParticipants participants: [Any]) {
        
        self.name = name
        self.uniqueId = partyId
        self.location = location
        self.startsAt = starts
        self.host = host
        self.partyType = type
        self.image = image
        self.inviteesList = invitees
        self.participantsList = participants
    }
}





