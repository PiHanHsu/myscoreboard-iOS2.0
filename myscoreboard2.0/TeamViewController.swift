//
//  TeamViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/1/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON
import UXTesting

class TeamViewController: MyScoredBoardBaseCollectionViewController,UICollectionViewDataSource, TeamCollectionViewCellDelegate {
    
    var rankData:JSON = []
    var gameType: String = GameType.single
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
        self.collectionView?.registerNib(UINib(nibName: "TeamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TeamCollectionViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        UXTestingManager.sharedInstance().heatMapStartWithViewName("Team page")
    }
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Teams.sharedInstance.teams.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TeamCollectionViewCell", forIndexPath: indexPath) as! TeamCollectionViewCell
        
        if indexPath.row == Teams.sharedInstance.teams.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addTeamCollectionViewCell", forIndexPath: indexPath) as! MyScoreBoardBaseCollectionViewCell
            cell.transform = checkTransform(indexPath.row)
            return cell
        }else{
            cell.team = Teams.sharedInstance.teams[indexPath.row]
            cell.teamNameLabel.text = cell.team?.teamName!
            cell.timeLabel.text = (cell.team?.gameDay!)! + " " + (cell.team?.gameTimeHour)!
            cell.placeLabel.text = cell.team?.placeName
            cell.startGameButton.tag = indexPath.row
            cell.startGameButton.addTarget(self, action: #selector(TeamViewController.startGame), forControlEvents: .TouchUpInside)
            cell.teamPlayersCollectionView?.reloadData()
            cell.delegate = self
        }
        cell.transform = checkTransform(indexPath.row)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == Teams.sharedInstance.teams.count {
          performSegueWithIdentifier("GoToAddNewTeamPage", sender: self)
          UXTestingManager.sharedInstance().customEvent("Pressed Add new team")
        }
    }
    
    func startGame(sender: UIButton) {
       Teams.sharedInstance.currentPlayingTeam = Teams.sharedInstance.teams[sender.tag]
        
       let alertController = UIAlertController(title: "選擇排賽方式", message: nil, preferredStyle: .ActionSheet)
       let autoAction = UIAlertAction(title: "自動排賽", style: .Default) { (UIAlertAction) in
        self.performSegueWithIdentifier("GoToSelectPlayerPage", sender: self)
       }
       let manualAction = UIAlertAction(title: "手動排賽", style: .Default) { (UIAlertAction) in
            self.performSegueWithIdentifier("GoToManualSchedualingPage", sender: self)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
       alertController.addAction(autoAction)
       alertController.addAction(manualAction)
        alertController.addAction(cancelAction)
       self.presentViewController(alertController, animated: true, completion: nil)
       
    }
    
    func addNewPlayer() {
       UXTestingManager.sharedInstance().customEvent("Pressed Add new Player")
       self.performSegueWithIdentifier("GoToAddNewPlayerPage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToAddNewPlayerPage" {
            let vc = segue.destinationViewController as! AddNewPlayerTableViewController
            vc.team = Teams.sharedInstance.teams[index]
        }else if segue.identifier == "GoToEditTeamPage" {
            let vc = segue.destinationViewController as! AddTeamTableViewController
            vc.team = Teams.sharedInstance.teams[index]
            vc.isEditMode = true
        }
        
    }
    
}
