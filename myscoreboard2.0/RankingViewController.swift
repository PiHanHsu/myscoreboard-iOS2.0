//
//  RankingViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let TRANSFORM_CELL_VALUE = CGAffineTransformMakeScale(0.8, 0.8)
    let ANIMATION_SPEED = 0.2
    var isfirstTimeTransform = true
    var widthSize:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        HttpManager.sharedInstance
        //            .request(
        //                HttpMethod.HttpMethodGet,
        //                apiFunc: APiFunction.GetRanking,
        //                param: ["auth_token": CurrentUser.sharedInstance.authToken!],
        //                success: { (code, data ) in
        //                    print("success")
        //                    print(data)
        //                    //self.success(code, data: data)
        //                }, failure: { (code, data) in
        //                    //self.failure(code!, data: data!)
        //                }, complete: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //計算每個 Cell 的大小，大小會決定一排會呈現幾個 Cell
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        widthSize = self.collectionView.frame.size.width - 150
        let heightSize = self.collectionView.frame.size.height - 200
        //print("cellWidth: \(widthSize)")
        
        return CGSize.init(width: widthSize, height: heightSize)
        //return CGSizeMake(300, 300)
    }
    
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return Teams.sharedInstance.teams.count + 1
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rankingCollectionViewCell", forIndexPath: indexPath) as! RankingCollectionViewCell
       
        if (indexPath.row == 0 && isfirstTimeTransform) { // make a bool and set YES initially, this check will prevent fist load transform
            isfirstTimeTransform = false
        }else{
            print("before: \(cell.frame.size.width)")
            cell.transform = TRANSFORM_CELL_VALUE
            print("after: \(cell.frame.size.width)")
            // the new cell will always be transform and without animation
        }
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let cellWidth: Float = Float(widthSize)
        print("scrollView cellWidth: \(cellWidth)")
        let pageWidth = Float(cellWidth + 10)
        print("pageWidth: \(pageWidth)")
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
        //print("targetContentOffset:\(targetContentOffset.memory.x)")
        scrollView.setContentOffset(CGPointMake(CGFloat(newTargetOffset), 0), animated: true)
        
        let index = Int(newTargetOffset / pageWidth)
        //print("index: \(index)")
        if index == 0 {
            let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! RankingCollectionViewCell
            
            UIView.animateWithDuration(ANIMATION_SPEED) {
                print("index0 normal")
                cell.transform = CGAffineTransformIdentity
            }
            
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 0)) {
                
                UIView.animateWithDuration(ANIMATION_SPEED) {
                    print("right")
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
                    print("left")
                    cell.transform = self.TRANSFORM_CELL_VALUE
                }
            }
            
            //right
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 0)) {
                
                UIView.animateWithDuration(ANIMATION_SPEED) {
                    print("right")
                    cell.transform = self.TRANSFORM_CELL_VALUE
                }
            }
        }
    }
}
