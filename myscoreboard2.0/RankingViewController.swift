//
//  RankingViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON


class RankingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let TRANSFORM_CELL_VALUE = CGAffineTransformMakeScale(0.9, 0.9)
    let ANIMATION_SPEED = 0.2
    var isTransformNeeded = true
    var widthSize:CGFloat?
    var heightSize:CGFloat?
    var spacing:CGFloat = 2.0
    var rankData:JSON = []
    var gameType: String = GameType.single
    var index = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gameTypeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodGet,
                apiFunc: APiFunction.GetRanking,
                param: ["auth_token": CurrentUser.sharedInstance.authToken!],
                success: { (code, data ) in
                    print(data)
                    self.rankData = data
                    self.collectionView.reloadData()
                }, failure: { (code, data) in
                }, complete: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectedGameType(sender: AnyObject) {
        
        isTransformNeeded = false
        
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
        
        self.collectionView.reloadData()
        
    }
    
    
    
    //collectionViewLayout
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        widthSize = self.view.frame.size.width * 0.75
        heightSize = self.view.frame.size.height * 0.7
        return CGSize.init(width: widthSize!, height: heightSize!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        let inset = (self.collectionView.frame.size.width - widthSize!) / 2
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return spacing
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
        
        if isTransformNeeded {
            if indexPath.row != 0 {
                cell.transform = TRANSFORM_CELL_VALUE
            }
        }else{
            if indexPath.row != index {
                cell.transform = TRANSFORM_CELL_VALUE
            }
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("y: \(scrollView.frame.origin.y)")
        
        isTransformNeeded = true
        let pageWidth = Float(widthSize! + spacing)
        let currentOffset = Float(scrollView.contentOffset.x)
        let targetOffset = Float(targetContentOffset.memory.x)
        var newTargetOffset = Float(0)
        
        let scrollViewWidth = Float(scrollView.contentSize.width)
        
        if (targetOffset > currentOffset){
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }else{
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        
        if newTargetOffset < 0{
            newTargetOffset = 0
        }else if newTargetOffset > scrollViewWidth{
            newTargetOffset = scrollViewWidth
        }
        
        targetContentOffset.memory = CGPointMake( CGFloat(currentOffset) , 0)
        scrollView.setContentOffset(CGPointMake(CGFloat(newTargetOffset), 0), animated: true)
        
        index = Int(newTargetOffset / pageWidth)
        if index == 0 {
            let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! RankingCollectionViewCell
            
            UIView.animateWithDuration(ANIMATION_SPEED) {
                cell.transform = CGAffineTransformIdentity
            }
            
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 0)) {
                
                UIView.animateWithDuration(ANIMATION_SPEED) {
                    cell.transform = self.TRANSFORM_CELL_VALUE
                }
            }
            
        }else {
            
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index , inSection: 0)) {
                
                UIView.animateWithDuration(ANIMATION_SPEED) {
                    cell.transform = CGAffineTransformIdentity
                }
            }
            //left
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index - 1, inSection: 0)) {
                
                UIView.animateWithDuration(ANIMATION_SPEED) {
                    cell.transform = self.TRANSFORM_CELL_VALUE
                }
            }
            //right
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 0)) {
                
                UIView.animateWithDuration(ANIMATION_SPEED) {
                    cell.transform = self.TRANSFORM_CELL_VALUE
                }
            }
        }
    }
}
