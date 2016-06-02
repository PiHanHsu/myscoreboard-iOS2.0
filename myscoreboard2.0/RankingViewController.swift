//
//  RankingViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON


class RankingViewController: MyScoredBoardBaseCollectionViewController, UICollectionViewDataSource {
    
    var spacing:CGFloat = 2.0
    var rankData:JSON = []
    var gameType: String = GameType.single
    
    
    @IBOutlet weak var gameTypeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.dataSource = self
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodGet,
                apiFunc: APiFunction.GetRanking,
                param: ["auth_token": CurrentUser.sharedInstance.authToken!],
                success: { (code, data ) in
                    print(data)
                    self.rankData = data
                    self.collectionView?.reloadData()
                }, failure: { (code, data) in
                }, complete: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectedGameType(sender: AnyObject) {
        
        switch self.gameTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            gameType = GameType.single
        case 1:
            gameType = GameType.double
        case 2:
            gameType = GameType.mix
            
        default:
            return
        }
        
        self.collectionView?.reloadData()
        
    }
    

    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Teams.sharedInstance.teams.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rankingCollectionViewCell", forIndexPath: indexPath) as! RankingCollectionViewCell
        
        cell.layer.borderColor = UIColor(red: 4.0/255.0, green: 190.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1.0
        
        cell.teamNameLabel.text = rankData["result"][indexPath.row]["team"].stringValue
        cell.rankData = rankData["result"][indexPath.row]
        cell.gameType = gameType
        cell.rankingTableView.reloadData()
        
        if indexPath.row != index {
            cell.transform = Params.TRANSFORM_CELL_VALUE
        }
        
        return cell
    }
    
}
