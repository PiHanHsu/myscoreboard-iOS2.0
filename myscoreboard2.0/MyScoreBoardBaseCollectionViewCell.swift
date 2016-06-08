//
//  MyScoreBoardBaseCollectionViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/8/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class MyScoreBoardBaseCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.mainBlueColor().CGColor
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 2.0
    }
}
