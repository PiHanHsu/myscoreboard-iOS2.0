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
        self.collectionView?.registerNib(UINib(nibName: "TeamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TeamCollectionViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Teams.sharedInstance.teams.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TeamCollectionViewCell", forIndexPath: indexPath) as! TeamCollectionViewCell
        
        
        
        if indexPath.row == Teams.sharedInstance.teams.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addTeamCollectionViewCell", forIndexPath: indexPath) as! MyScoreBoardBaseCollectionViewCell
            
            return cell
        }else{
            cell.team = Teams.sharedInstance.teams[indexPath.row]
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
