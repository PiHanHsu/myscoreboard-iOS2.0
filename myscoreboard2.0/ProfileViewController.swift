//
//  ProfileViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/23/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var bestDoubleTeammateImageView: UIImageView!
    @IBOutlet weak var bestDoubleTeammateName: UILabel!
    @IBOutlet weak var bestMixTeammateImageView: UIImageView!
    @IBOutlet weak var bestMixTeammateName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodGet,
                apiFunc: APiFunction.GetUserStats,
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
