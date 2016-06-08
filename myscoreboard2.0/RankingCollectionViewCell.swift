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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.rankingTableView.delegate = self
        self.rankingTableView.dataSource = self
        let footerView = UIView()
        footerView.frame = CGRectZero
        self.rankingTableView.tableFooterView = footerView
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch gameType {
        case GameType.single:
            return rankData["male_single"].count
        case GameType.double:
            return rankData["male_double"].count
        case GameType.mix:
            return rankData["male_mix"].count
        default:
            return 5
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingTableViewCell", forIndexPath: indexPath) as! RankingTableViewCell
        
        switch gameType {
        case GameType.single:
            cell.nameLabel.text = rankData["male_single"][indexPath.row]["user"].stringValue
            let rate = rankData["male_single"][indexPath.row]["rate"].stringValue
            let wins = rankData["male_single"][indexPath.row]["wins"].stringValue
            let losses = rankData["male_single"][indexPath.row]["losses"].stringValue
            cell.rateLabel.text = "勝率：\(rate)% "
            cell.winsAndLossesLabel.text = "\(wins) 勝\(losses) 敗"
            cell.userImageView.sd_setImageWithURL(NSURL(string:rankData["male_single"][indexPath.row]["user_photo"].stringValue))
        case GameType.double:
            cell.nameLabel.text = rankData["male_double"][indexPath.row]["user"].stringValue
            let rate = rankData["male_double"][indexPath.row]["rate"].stringValue
            let wins = rankData["male_double"][indexPath.row]["wins"].stringValue
            let losses = rankData["male_double"][indexPath.row]["losses"].stringValue
            cell.rateLabel.text = "勝率：\(rate)% "
            cell.winsAndLossesLabel.text = "\(wins) 勝\(losses) 敗"
            cell.userImageView.sd_setImageWithURL(NSURL(string:rankData["male_double"][indexPath.row]["user_photo"].stringValue))
            
        case GameType.mix:
            cell.nameLabel.text = rankData["male_mix"][indexPath.row]["user"].stringValue
            let rate = rankData["male_mix"][indexPath.row]["rate"].stringValue
            let wins = rankData["male_mix"][indexPath.row]["wins"].stringValue
            let losses = rankData["male_mix"][indexPath.row]["losses"].stringValue
            cell.rateLabel.text = "勝率：\(rate)% "
            cell.winsAndLossesLabel.text = "\(wins) 勝\(losses) 敗"
            cell.userImageView.sd_setImageWithURL(NSURL(string:rankData["male_mix"][indexPath.row]["user_photo"].stringValue))
        default:
            return cell
        }
        
            
        cell.rankingLabel.text = "\(indexPath.row + 1)"
        
        return cell
        
    }
    

    
}
