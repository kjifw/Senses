//
//  PartyListTableViewCell.swift
//  Senses
//
//  Created by Jeff on 4/3/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class PartyListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var host: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
