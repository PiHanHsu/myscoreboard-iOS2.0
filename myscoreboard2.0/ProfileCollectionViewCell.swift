//
//  ProfileCollectionViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/1/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ProfileCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    let gameTableViewCell = "GameTableViewCell"
    let bestPartnerTableViewCell = "BestPartnetTableViewCell"
    let profileInfoTableViewCell = "ProfileInfoTableViewCell"
    var statsData:JSON = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        
        self.profileTableView.estimatedRowHeight = 60
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.profileTableView.registerNib(UINib(nibName: profileInfoTableViewCell, bundle: nil), forCellReuseIdentifier: profileInfoTableViewCell)
        self.profileTableView.registerNib(UINib(nibName: gameTableViewCell, bundle: nil), forCellReuseIdentifier: gameTableViewCell)
        self.profileTableView.registerNib(UINib(nibName: bestPartnerTableViewCell, bundle: nil), forCellReuseIdentifier: bestPartnerTableViewCell)
        
        
        let footerView = UIView()
        footerView.frame = CGRectZero
        self.profileTableView.tableFooterView = footerView
        
        self.userNameLabel.text = CurrentUser.sharedInstance.username!
        
        
    }
    
    
    //tableView Delegate
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case 0:
                let title = ""
                return title
            case 1:
                let title = "近期比分"
                return title
            case 2:
                let title = "最佳搭檔"
                return title
                
            default:
                break
            }
        
            return ""
    }
    
    
    //tableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
            
        default:
            break
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.teamNameLabel.text = statsData["team"].stringValue
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(profileInfoTableViewCell, forIndexPath: indexPath) as! ProfileInfoTableViewCell
            let games = statsData["games"].stringValue
            let rate = statsData["rate"].stringValue
            let wins = statsData["wins"].stringValue
            let losses = statsData["losses"].stringValue
            cell.gameCountLabel.text = "比賽場次：\(games)"
            cell.rateLabel.text = "勝率: \(rate)%"
            cell.winsAndLossesLabel.text = "勝負場次：\(wins)勝\(losses)敗"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(gameTableViewCell, forIndexPath: indexPath) as! GameTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(bestPartnerTableViewCell, forIndexPath: indexPath) as! BestPartnetTableViewCell
            cell.bestDoublePartnerNameLabel.text = statsData["best_double_name"].stringValue
            
            cell.bestDoublePartnerImageView.layer.cornerRadius = 25.0
            cell.bestDoublePartnerImageView.clipsToBounds = true
            if statsData["best_double_photo"] != nil {
                cell.bestDoublePartnerImageView.sd_setImageWithURL(NSURL(string: statsData["best_double_photo"].stringValue))
            }
            
            cell.bestMixPartnerNameLabel.text = statsData["best_mix_name"].stringValue
            
            cell.bestMixPartnerImageView.layer.cornerRadius = 25.0
            cell.bestMixPartnerImageView.clipsToBounds = true

            if statsData["best_mix_photo"] != nil {
                cell.bestMixPartnerImageView.sd_setImageWithURL(NSURL(string: statsData["best_mix_name"].stringValue))
            }
            
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
    
}