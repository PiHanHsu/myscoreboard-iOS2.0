//
//  RankingCollectionViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/25/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class RankingCollectionViewCell: MyScoreBoardBaseCollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var teamNameLabel: UILabel!
    var rankData:JSON = []
    var gameType: String = ""
    var rankVar = rankVariable()
    var currentGender = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.rankingTableView.delegate = self
        self.rankingTableView.dataSource = self
        let footerView = UIView()
        footerView.frame = CGRectZero
        self.rankingTableView.tableFooterView = footerView
        
        rankVar.gameType = gameType
        if CurrentUser.sharedInstance.gender! == "male" {
            rankVar.gender = "male"
            currentGender = "male"
        }else{
            rankVar.gender = "female"
            currentGender = "female"
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        rankVar.gameType = gameType
        return rankData[rankVar.rankType].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingTableViewCell", forIndexPath: indexPath) as! RankingTableViewCell
        
        cell.nameLabel.text = rankData[rankVar.rankType][indexPath.row]["user"].stringValue
        rankVar.gameType = gameType
        let rate = rankData[rankVar.rankType][indexPath.row]["rate"].floatValue
        let wins = rankData[rankVar.rankType][indexPath.row]["wins"].stringValue
        let losses = rankData[rankVar.rankType][indexPath.row]["losses"].stringValue
        cell.rateLabel.text = "勝率：" + (NSString(format: "%.2f", rate) as String) + "%"
        cell.winsAndLossesLabel.text = "\(wins) 勝\(losses) 敗"
        cell.userImageView.sd_setImageWithURL(NSURL(string:rankData[rankVar.rankType][indexPath.row]["user_photo"].stringValue))
        cell.rankingLabel.text = "\(indexPath.row + 1)"
        
        return cell
        
    }
    
    @IBAction func switchGender(sender: AnyObject) {
        if currentGender == "male" {
            rankVar.gender = "female"
            currentGender = "female"
        }else{
            currentGender = "male"
            rankVar.gender = "male"
        }
        self.rankingTableView.reloadData()
    }
    
}


struct rankVariable {
    var gender = ""
    var gameType = ""
    var rankType: String {
        get {
            return "\(gender)_\(gameType)"
        }
    }
}
