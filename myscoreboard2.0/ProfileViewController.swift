//
//  ProfileViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: MyScoredBoardBaseCollectionViewController, UICollectionViewDataSource {
    
    var rankData:JSON = []
    var gameType: String = GameType.single
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        if indexPath.row != index {
            cell.transform = Params.TRANSFORM_CELL_VALUE
        }
        
        return cell
    }
    
}
