//
//  UserListModelExtensions.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import Foundation

extension UserListModel {
    convenience init(withDict item: Dictionary<String, Any>) {
        var picture: String = ""
        var city: String = ""
        
        if(item["picture"] != nil) {
            picture = item["picture"] as! String
        }
        
        if(item["city"] != nil) {
            city = item["city"] as! String
        }
        
        self.init(withUsername: item["username"] as! String,
                  withPicture: picture,
                  withCity: city,
                  withKudos: "\(item["kudos"]!)")
    }
}
