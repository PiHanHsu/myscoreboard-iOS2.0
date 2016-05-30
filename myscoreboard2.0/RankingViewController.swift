//
//  RankingViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let TRANSFORM_CELL_VALUE = CGAffineTransformMakeScale(0.9, 0.9)
    let ANIMATION_SPEED = 0.2
    var isfirstTimeTransform = true
    var widthSize:CGFloat?
    var heightSize:CGFloat?
    var spacing:CGFloat?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //                HttpManager.sharedInstance
        //                    .request(
        //                        HttpMethod.HttpMethodGet,
        //                        apiFunc: APiFunction.GetRanking,
        //                        param: ["auth_token": CurrentUser.sharedInstance.authToken!],
        //                        success: { (code, data ) in
        //                            print("success")
        //                            print(data)
        //                            //self.success(code, data: data)
        //                        }, failure: { (code, data) in
        //                            //self.failure(code!, data: data!)
        //                        }, complete: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        widthSize = self.collectionView.frame.size.width * 0.75
        heightSize = self.collectionView.frame.size.height * 0.75
        
        return CGSize.init(width: widthSize!, height: heightSize!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        let inset = (self.collectionView.frame.size.width - widthSize!) / 2 - 8
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        spacing = 2
        return spacing!
    }
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Teams.sharedInstance.teams.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rankingCollectionViewCell", forIndexPath: indexPath) as! RankingCollectionViewCell
        
        cell.layer.borderColor = UIColor.orangeColor().CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1.0
        
        cell.teamNameLabel.text = Teams.sharedInstance.teams[indexPath.row].TeamName
        
        if (indexPath.row == 0 && isfirstTimeTransform) { // make a bool and set YES initially, this check will prevent fist load transform
            isfirstTimeTransform = false
        }else{
            //print("before: \(cell.frame.size.width)")
            cell.transform = TRANSFORM_CELL_VALUE
            //print("after: \(cell.frame.size.width)")
            // the new cell will always be transform and without animation
        }
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(widthSize! + spacing!)
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
        
        print("newTargetOffset:\(newTargetOffset)")
        targetContentOffset.memory = CGPointMake( CGFloat(currentOffset) , 0)
        scrollView.setContentOffset(CGPointMake(CGFloat(newTargetOffset), 0), animated: true)
        
        let index = Int(newTargetOffset / pageWidth)
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
