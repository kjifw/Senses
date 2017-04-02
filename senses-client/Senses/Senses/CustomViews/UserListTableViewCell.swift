//
//  UserListTableViewCell.swift
//  Senses
//
//  Created by Jeff on 4/3/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var kudos: UILabel!
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
