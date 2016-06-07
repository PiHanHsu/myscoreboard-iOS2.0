//
//  EditProfileTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/18/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileTableViewController: UITableViewController {
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var headPhotoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CurrentUser.sharedInstance.photo_url != nil) {
            headPhotoImageView.layer.cornerRadius = 50
            headPhotoImageView.clipsToBounds = true
            headPhotoImageView.sd_setImageWithURL(NSURL(string: CurrentUser.sharedInstance.photo_url!))
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3
        case 1:
            return 1
            
        default:
            return 0
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        HttpManager.sharedInstance
            .request(
                
                HttpMethod.HttpMethodPatch,
                apiFunc: APiFunction.EditUser,
                param: ["auth_token": CurrentUser.sharedInstance.authToken!,
                    "username" : userNameTextField.text!,],
                success: { (code, data ) in
                    print("success")
                    
                }, failure: { (code, data) in
                    //self.failure(code!, data: data!)
                }, complete: nil)
        
    }
    @IBAction func logout(sender: AnyObject) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let token = userDefault.objectForKey("token") as! String
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPost,
                apiFunc: APiFunction.Logout,
                param: ["auth_token": token],
                success: { (code, data ) in
                    Teams.sharedInstance.teams.removeAll()
                    
                    //neeback to root viewcontroller
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let rootVC: UIViewController = sb.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(rootVC, animated: true, completion: nil)
                    
                }, failure: { (code, data) in
                    //self.failure(code!, data: data!)
                }, complete: nil)
  
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
