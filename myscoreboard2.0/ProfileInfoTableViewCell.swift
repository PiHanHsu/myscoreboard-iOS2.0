//
//  ProfileInfoTableViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/6/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var gameCountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var winsAndLossesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
