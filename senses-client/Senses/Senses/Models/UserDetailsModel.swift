//
//  UserDetailsModel.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import Foundation

class UserDetailsModel {
    var username: String?
    var email: String?
    var city: String?
    var picture: String?
    var age: String?
    var gender: String?
    var about: String?
    var kudos: String?
    var genderPrefs: [Any]?
    var invitationsList: [Any]?
    var partyHistory: [Any]?
    
    init(withUsername username: String,
         withEmail email: String,
         withCity city: String,
         withPicture picture: String,
         withAge age: String,
         withGender gender: String,
         withInformation about: String,
         withKudos kudos: String,
         withGenderPrefs prefs: [Any],
         withInvitationsList invitationsList: [Any],
         withPartyHistory partyHistory: [Any]) {
     
        self.username = username
        self.email = email
        self.city = city
        self.picture = picture
        self.age = age
        self.gender = gender
        self.about = about
        self.kudos = kudos
        self.genderPrefs = prefs
        self.invitationsList = invitationsList
        self.partyHistory = partyHistory
    }
}







