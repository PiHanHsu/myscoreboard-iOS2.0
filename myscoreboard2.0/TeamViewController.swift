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
    var selectedTeam: Team?
    
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
            cell.startGameButton.tag = indexPath.row
            cell.startGameButton.addTarget(self, action: #selector(TeamViewController.startGame), forControlEvents: .TouchUpInside)
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
    
    func startGame(sender: UIButton) {
       
       selectedTeam = Teams.sharedInstance.teams[sender.tag]
        
       let alertController = UIAlertController(title: "選擇排賽模式", message: nil, preferredStyle: .ActionSheet)
        let autoAction = UIAlertAction(title: "自動排賽", style: .Default, handler: {UIAlertAction in
            self.performSegueWithIdentifier("GoToSelectPlayerPage", sender: self)
        })
        let manualAction = UIAlertAction(title: "手動排賽", style: .Default, handler:{UIAlertAction in
            self.performSegueWithIdentifier("GoToStartGamePage", sender: self)
        })

        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alertController.addAction(autoAction)
        alertController.addAction(manualAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToSelectPlayerPage" {
            let vc =  segue.destinationViewController as! SelectPlayerViewController
            vc.team = selectedTeam
        }
    }
}
