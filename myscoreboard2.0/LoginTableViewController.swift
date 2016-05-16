//
//  LoginTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/16/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class LoginTableViewController: UITableViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!

    var headerHeight = UIScreen.mainScreen().bounds.height * 0.66
    var footerHeight = UIScreen.mainScreen().bounds.height * 0.075
    
//    var tableCellHeight = ( UIScreen.mainScreen().bounds.height - headerHeight - footerHeight - 20 ) / 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg_login_page"))
    
    self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: headerHeight)
    
    self.footerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: UIScreen.mainScreen().bounds.width, height: footerHeight )
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    @IBAction func fbLogin(sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookresult, facebookError) -> Void in
            
            if facebookError != nil {
                print("FaceBook login failed. Error: \(facebookError)")
            }else if facebookresult.isCancelled{
                print("Facebook login was cancelled.")
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print(accessToken)
                
                HttpManager.sharedInstance
                    .request(
                        HttpMethod.HttpMethodPost,
                        apiFunc: APiFunction.FBLogin,
                        param: ["access_token":accessToken],
                        success: { (code, data ) in
                            self.success(code, data: data)
                        }, failure: { (code, data) in
                            self.failure(code!, data: data!)
                        }, complete: nil)
            }
        })

    }
    
    func success(code:Int, data:JSON ) {
        print("\(#function)")
        print(code)
        print(data)
    }
    
    func failure(code:Int, data:JSON ) {
        print("\(#function)")
        print(code)
        print(data)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
