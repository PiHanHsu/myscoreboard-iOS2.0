//
//  SelectPlayerViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/13/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
protocol ChangePlayerDelegate: class {
    func changePlayer(player: Player, playerIndex: Int)
}

class SelectPlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var selectPlayersCollectionView: UICollectionView!
    @IBOutlet var startButton: UIButton!
    let team = Teams.sharedInstance.currentPlayingTeam
    var selectedPlayers = [Player]()
    var players = [Player]()
    var isChangePlayerMode = false
    weak var delegate = ChangePlayerDelegate?()
    var changePlayerIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isChangePlayerMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(SelectPlayerViewController.cancel))
            footerView.hidden = true
        }else{
            players = team.players
        }
        
        self.selectPlayersCollectionView.delegate = self
        self.selectPlayersCollectionView.dataSource = self
        selectPlayersCollectionView.registerNib(UINib(nibName: "PlayerCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCardCollectionViewCell")
        
        //set up startButton
        startButton.enabled = false
        startButton.layer.cornerRadius = 8.0
        startButton.clipsToBounds = true
    }
    
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CollectionView Delegate
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = (self.selectPlayersCollectionView!.frame.size.width)/3 - 10-10
        return CGSize.init(width: size, height: size*1.25)
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets{

        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlayerCardCollectionViewCell", forIndexPath: indexPath) as! PlayerCardCollectionViewCell
        
        let player = players[indexPath.row]
        cell.playerName.text = player.playerName
        cell.selectedButton.tag = indexPath.row
        cell.selectedButton.addTarget(self, action: #selector(SelectPlayerViewController.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if let imageUrl = player.playerImageUrl {
            if imageUrl != "" {
                cell.playerImage.sd_setImageWithURL(NSURL(string: imageUrl)!)
            }
        }
        
        return cell
    }
    
    func buttonClicked(sender:UIButton)
    {
        if isChangePlayerMode{
            self.delegate?.changePlayer(players[sender.tag], playerIndex: changePlayerIndex)
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            let cell = self.selectPlayersCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: sender.tag , inSection: 0)) as! PlayerCardCollectionViewCell
            if cell.isPlayerSelected {
                cell.isPlayerSelected = false
                cell.selectedButton.layer.borderWidth = 0
                selectedPlayers.removeObject(players[sender.tag])
            }else{
                cell.isPlayerSelected = true
                cell.selectedButton.layer.cornerRadius = cell.selectedButton.frame.size.width/2
                cell.selectedButton.clipsToBounds = true
                cell.selectedButton.layer.borderColor = UIColor.redColor().CGColor
                cell.selectedButton.layer.borderWidth = 2.0
                selectedPlayers.append(players[sender.tag])
            }
            checkStartButtonEnable()
        }
    }
    
    func checkStartButtonEnable() {
        var m = 0
        var f = 0
        for player in selectedPlayers {
            if player.gender == "male" {
                m += 1
            }else {
                f += 1
            }
        }
        if (m > 1 && f > 1) || m > 3 || f > 3 {
            startButton.enabled = true
        }else {
            startButton.enabled = false
        }
        
    }
    
     // MARK: - Navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToGameScorePage" {
            let vc =  segue.destinationViewController as! GameScoreViewController
            vc.selectedPlayers = selectedPlayers
        }
     }
 
    //TODO - change method to unwindForSegue
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
   
    
}
