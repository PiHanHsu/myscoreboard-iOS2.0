//
//  GameTableViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/2/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var team1Player1NameLabel: UILabel!
    @IBOutlet weak var team1Player2NameLabel: UILabel!
    @IBOutlet weak var team2Player1NameLabel: UILabel!
    @IBOutlet weak var team2Player2NameLabel: UILabel!
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
