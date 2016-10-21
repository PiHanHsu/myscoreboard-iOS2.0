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
    
    var statsData:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodGet,
                apiFunc: APiFunction.GetUserStats,
                param: ["auth_token": CurrentUser.sharedInstance.authToken!],
                success: { (code, data ) in
                    self.statsData = data["result"]
                    //print(self.statsData )
                    self.collectionView?.reloadData()
                }, failure: { (code, data) in
                    print("error: \(data)")
                }, complete: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
        
        navigationItem.rightBarButtonItem?.enabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Teams.sharedInstance.teams.count > 0 {
        return Teams.sharedInstance.teams.count
        }else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCollectionViewCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        cell.statsData = statsData[indexPath.row]
        cell.transform = checkTransform(indexPath.row)
        cell.profileTableView.reloadData()
        
        return cell
    }
    
}
