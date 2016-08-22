//
//  SingleGameTableViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 8/22/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class SingleGameTableViewCell: UITableViewCell {

    @IBOutlet var team1Player1NameLabel: UILabel!
    @IBOutlet var team2Player1NameLabel: UILabel!
    @IBOutlet var team1ScoreLabel: UILabel!
    @IBOutlet var team2ScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
