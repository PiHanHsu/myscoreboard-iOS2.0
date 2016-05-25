//
//  RankingViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //let TRANSFORM_CELL_VALUE = CGAffineTransformMakeScale(0.8, 0.8)
    //let ANIMATION_SPEED = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Token.sharedInstance.auth_token)
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodGet,
                apiFunc: APiFunction.GetRanking,
                param: ["auth_token": Token.sharedInstance.auth_token],
                success: { (code, data ) in
                    print("success")
                    print(data)
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
    @IBOutlet weak var collerctionView: UICollectionView!
    
    //計算每個 Cell 的大小，大小會決定一排會呈現幾個 Cell
//    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        //let widthSize = self.teamCollectionView.frame.size.width
//        //let heightSize = self.teamCollectionView.frame.size.height
//        //return CGSize.init(width: widthSize, height: heightSize)
//        return CGSizeMake(300, 300)
//    }
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return Teams.sharedInstance.teams.count + 1
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rankingCollectionViewCell", forIndexPath: indexPath)
        //cell.transform = TRANSFORM_CELL_VALUE
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(200+30)
        let currentOffset = Float(scrollView.contentOffset.x)
        let targetOffset = Float(targetContentOffset.memory.x)
        var newTargetOffset = Float(0)
        print("\(self.view.frame.size.width)")
        print("currentOffset:\(currentOffset)")
        print("targetOffset:\(targetOffset)")
        
        let scrollViewWidth = Float(scrollView.contentSize.width)
        
        print("scrollVierWidth: \(scrollViewWidth)")
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
        
//        if newTargetOffset < 0 {
//            newTargetOffset = 0
//        } else if newTargetOffset > currentOffset {
//            newTargetOffset = currentOffset
//        }
        
        print("newTargetOffset:\(newTargetOffset)")
        targetContentOffset.memory = CGPointMake( CGFloat(currentOffset) , 0)
        print("targetContentOffset:\(targetContentOffset.memory.x)")
        scrollView.setContentOffset(CGPointMake(CGFloat(newTargetOffset), 0), animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
