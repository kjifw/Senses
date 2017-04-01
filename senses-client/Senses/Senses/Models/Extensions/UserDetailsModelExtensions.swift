//
//  UserDetailsModelExtensions.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import Foundation

extension UserDetailsModel {
    convenience init(withDict item: Dictionary<String, Any>) {
        var prefs: [Any] = []
        var invitationsList: [Any] = []
        var historyList: [Any] = []
        
        if(item["genderPreferences"] != nil) {
            prefs = item["genderPreferences"] as! [Any]
        }
        
        if(item["invitationsList"] != nil) {
            invitationsList = item["invitationsList"] as! [Any]
        }
        
        if(item["partyHistory"] != nil) {
            historyList = item["partyHistory"] as! [Any]
        }
        
        self.init(withUsername: item["username"] as! String,
                  withEmail: item["email"] as! String,
                  withCity: item["city"] as! String,
                  withPicture: item["picture"] as! String,
                  withAge: "\(item["age"]!)",
                  withGender: item["gender"] as! String,
                  withInformation: item["about"] as! String,
                  withKudos: "\(item["kudos"]!)",
                  withGenderPrefs: prefs,
                  withInvitationsList: invitationsList,
                  withPartyHistory: historyList)
    }
}









