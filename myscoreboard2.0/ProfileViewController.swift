//
//  ProfileViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isTransformNeeded = true
    var widthSize:CGFloat?
    var heightSize:CGFloat?
    var rankData:JSON = []
    var gameType: String = GameType.single
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false

        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodGet,
                apiFunc: APiFunction.GetUserStats,
                param: ["auth_token": CurrentUser.sharedInstance.authToken!],
                success: { (code, data ) in
                    print("success")
                    //print(data)
                    //self.success(code, data: data)
                }, failure: { (code, data) in
                    //self.failure(code!, data: data!)
                }, complete: nil)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return Params.spacing
    }
   
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Teams.sharedInstance.teams.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCollectionViewCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        cell.layer.borderColor = UIColor(red: 4.0/255.0, green: 190.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1.0
        
//        cell.teamNameLabel.text = rankData["result"][indexPath.row]["team"].stringValue
//        cell.rankData = rankData["result"][indexPath.row]
//        cell.gameType = gameType
//        cell.rankingTableView.reloadData()
        
        if isTransformNeeded {
            if indexPath.row != 0 {
                cell.transform = Params.TRANSFORM_CELL_VALUE
            }
        }else{
            if indexPath.row != index {
                cell.transform = Params.TRANSFORM_CELL_VALUE
            }
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        isTransformNeeded = true
        let pageWidth = Float(widthSize! + Params.spacing)
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
            let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! ProfileCollectionViewCell
            
            UIView.animateWithDuration(Params.ANIMATION_SPEED) {
                cell.transform = CGAffineTransformIdentity
            }
            
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 0)) {
                
                UIView.animateWithDuration(Params.ANIMATION_SPEED) {
                    cell.transform = Params.TRANSFORM_CELL_VALUE
                }
            }
            
        }else {
            
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index , inSection: 0)) {
                
                UIView.animateWithDuration(Params.ANIMATION_SPEED) {
                    cell.transform = CGAffineTransformIdentity
                }
            }
            //left
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index - 1, inSection: 0)) {
                
                UIView.animateWithDuration(Params.ANIMATION_SPEED) {
                    cell.transform = Params.TRANSFORM_CELL_VALUE
                }
            }
            //right
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 0)) {
                
                UIView.animateWithDuration(Params.ANIMATION_SPEED) {
                    cell.transform = Params.TRANSFORM_CELL_VALUE
                }
            }
        }
    }

   
}
