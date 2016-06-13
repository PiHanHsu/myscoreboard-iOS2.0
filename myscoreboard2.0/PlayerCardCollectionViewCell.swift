//
//  PlayerCardCollectionViewCell.swift
//  MyScoreBoardapp
//
//  Created by stephanie yang on 2016/4/21.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

import UIKit

class PlayerCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var frameView: UIImageView!
    @IBOutlet weak var selectedButton: UIButton!
    
    var isPlayerSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code   
//
//        self.playerImage.clipsToBounds = true
//        self.playerImage.layer.masksToBounds = true
//        self.playerImage.layer.cornerRadius = self.playerImage.frame.size.width/2
     
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.playerImage.layer.masksToBounds = true
        self.playerImage.layer.cornerRadius = self.playerImage.frame.size.width/2
        if isPlayerSelected {
            self.selectedButton.layer.cornerRadius = self.selectedButton.frame.size.width/2
            self.selectedButton.clipsToBounds = true
            self.selectedButton.layer.borderColor = UIColor.redColor().CGColor
            self.selectedButton.layer.borderWidth = 2.0
        }
        //print("width: \(self.playerImage.frame.size.width)")
    }
}
