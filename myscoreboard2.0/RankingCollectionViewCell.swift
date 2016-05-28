//
//  RankingCollectionViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/25/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class RankingCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var rankingTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.rankingTableView.delegate = self
        self.rankingTableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingTableViewCell", forIndexPath: indexPath) as! RankingTableViewCell
        
        return cell
        
    }
    

    
}
