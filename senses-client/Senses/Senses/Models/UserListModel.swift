//
//  UserListModel.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import Foundation

class UserListModel {
    var username: String?
    var picture: String?
    var city: String?
    var kudos: String?
    
    init(withUsername username: String,
         withPicture picture: String,
         withCity city: String,
         withKudos kudos: String) {
        
        self.username = username
        self.picture = picture
        self.city = city
        self.kudos = kudos
    }
}
