//
//  BestPartnetTableViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/2/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class BestPartnetTableViewCell: UITableViewCell {

    @IBOutlet weak var bestDoublePartnerImageView: UIImageView!
    @IBOutlet weak var bestDoublePartnerNameLabel: UILabel!
    @IBOutlet weak var bestMixPartnerImageView: UIImageView!
    @IBOutlet weak var bestMixPartnerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
