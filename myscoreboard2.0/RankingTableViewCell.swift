//
//  RankingTableViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/25/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var winsAndLossesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = 25.0
        self.userImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
