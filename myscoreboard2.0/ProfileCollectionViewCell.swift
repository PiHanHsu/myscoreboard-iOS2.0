//
//  ProfileCollectionViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/1/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let gameTableViewCell = "GameTableViewCell"
    let bestPartnerTableViewCell = "BestPartnetTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        
        self.profileTableView.estimatedRowHeight = 60
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        
        self.profileTableView.registerNib(UINib(nibName: gameTableViewCell, bundle: nil), forCellReuseIdentifier: gameTableViewCell)
        self.profileTableView.registerNib(UINib(nibName: bestPartnerTableViewCell, bundle: nil), forCellReuseIdentifier: bestPartnerTableViewCell)
        
        
        let footerView = UIView()
        footerView.frame = CGRectZero
        self.profileTableView.tableFooterView = footerView
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("profileInfoTableViewCell", forIndexPath: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(gameTableViewCell, forIndexPath: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(bestPartnerTableViewCell, forIndexPath: indexPath)
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
    
}