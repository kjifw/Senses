//
//  PartyListModel.swift
//  Senses
//
//  Created by Jeff on 3/29/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class PartyListModel {
    var name: String?
    var host: String?
    
    init(withName name: String, andHost host: String) {
        self.name = name
        self.host = host
    }
}
