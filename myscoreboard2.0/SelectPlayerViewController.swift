//
//  SelectPlayerViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/13/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class SelectPlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var selectPlayersCollectionView: UICollectionView!
    var team: Team?
    var selectedPlayers = [Player]()
    var isChangePlayerMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isChangePlayerMode {
            let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
            let navigationItem = UINavigationItem()
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(SelectPlayerViewController.cancel))
            navigationBar.items = [navigationItem]
            self.view.addSubview(navigationBar)
            
       
            
        }
        self.selectPlayersCollectionView.delegate = self
        self.selectPlayersCollectionView.dataSource = self
        selectPlayersCollectionView.registerNib(UINib(nibName: "PlayerCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCardCollectionViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    //計算 minimumInteritemSpacing 的間隔是多少
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    //計算 LineSpacing 的間隔是多少
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if team != nil {
            return team!.players.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlayerCardCollectionViewCell", forIndexPath: indexPath) as! PlayerCardCollectionViewCell
        
        let player = team!.players[indexPath.row]
        cell.playerName.text = player.playerName
        cell.selectedButton.tag = indexPath.row
        cell.selectedButton.addTarget(self, action: #selector(SelectPlayerViewController.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        if cell.isPlayerSelected {
            
        }
        if let imageUrl = player.playerImageUrl {
            if imageUrl != "" {
                cell.playerImage.sd_setImageWithURL(NSURL(string: imageUrl)!)
            }
        }else{
            cell.playerImage.image = UIImage()
        }
        
        
        return cell
    }
    
    func buttonClicked(sender:UIButton)
    {
        let cell = self.selectPlayersCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: sender.tag , inSection: 0)) as! PlayerCardCollectionViewCell
        if cell.isPlayerSelected {
            cell.isPlayerSelected = false
            cell.selectedButton.layer.borderWidth = 0
            selectedPlayers.removeObject(team!.players[sender.tag])
        }else{
            cell.isPlayerSelected = true
            cell.selectedButton.layer.cornerRadius = cell.selectedButton.frame.size.width/2
            cell.selectedButton.clipsToBounds = true
            cell.selectedButton.layer.borderColor = UIColor.redColor().CGColor
            cell.selectedButton.layer.borderWidth = 2.0
            selectedPlayers.append(team!.players[sender.tag])
        }
        
        

    }
    
     // MARK: - Navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToGameScorePage" {
            let vc =  segue.destinationViewController as! GameScoreViewController
            vc.selectedPlayers = selectedPlayers
            vc.team = team!
        }
     }
 
    
}
