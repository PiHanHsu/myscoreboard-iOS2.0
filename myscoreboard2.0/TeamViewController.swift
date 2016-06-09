//
//  TeamViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/1/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class TeamViewController: MyScoredBoardBaseCollectionViewController,UICollectionViewDataSource {
    
    var rankData:JSON = []
    var gameType: String = GameType.single
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Teams.sharedInstance.teams.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("teamCollectionViewCell", forIndexPath: indexPath) as! TeamCollectionViewCell
        
        if indexPath.row == Teams.sharedInstance.teams.count {
            let label = UILabel()
            label.text = "新增球隊"
            label.frame = CGRectMake(50, 200, 100, 21)
            cell.addSubview(label)
        }
        
        if indexPath.row != index {
            cell.transform = Params.TRANSFORM_CELL_VALUE
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == Teams.sharedInstance.teams.count {
          performSegueWithIdentifier("GoToAddNewTeamPage", sender: self)
        }
        
    }
}
