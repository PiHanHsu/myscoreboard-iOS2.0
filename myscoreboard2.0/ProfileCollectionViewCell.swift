//
//  ProfileCollectionViewCell.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/1/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       //self.profileTableView.dataSource = self
       //self.profileTableView.delegate = self
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileInfoTableViewCell", forIndexPath: indexPath)
        return cell
    }
    
}