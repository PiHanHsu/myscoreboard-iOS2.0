//
//  EditProfileTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/18/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileTableViewController: MyScoreBoardEditInfoTableViewController {
    //@IBOutlet weak var photoButton: UIButton!
    //@IBOutlet weak var headPhotoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CurrentUser.sharedInstance.photo_url != nil) {
            photoImageView.sd_setImageWithURL(NSURL(string: CurrentUser.sharedInstance.photo_url!))
            cameraImageView.hidden = true
            uploadImageLabel.hidden = true
        }
        self.userNameTextField.text = CurrentUser.sharedInstance.username
        self.emailTextField.text = CurrentUser.sharedInstance.email
        
        if CurrentUser.sharedInstance.gender == "male" {
            self.genderLabel.text = "男"
        }else if CurrentUser.sharedInstance.gender == "female" {
            self.genderLabel.text = "女"
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            selectGender(tableView.cellForRowAtIndexPath(indexPath)!)
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPatch,
                apiFunc: APiFunction.EditUser,
                param: ["auth_token": CurrentUser.sharedInstance.authToken!,
                         "username" : userNameTextField.text!,
                           "gender" : genderLabel.text!,
                            "email" : emailTextField.text!],
                success: { (code, data ) in
                    let alertController = UIAlertController(title: "更新成功", message: "", preferredStyle: .Alert)
                    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }, failure: { (code, data) in
                    //self.failure(code!, data: data!)
                }, complete: nil)
        
    }
    @IBAction func logout(sender: AnyObject) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let token = userDefault.objectForKey("auth_token") as! String
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPost,
                apiFunc: APiFunction.Logout,
                param: ["auth_token": token],
                success: { (code, data ) in
                    Teams.sharedInstance.teams.removeAll()
                    userDefault.removeObjectForKey("auth_token")
                    
                    //back to root viewcontroller
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let rootVC: UIViewController = sb.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(rootVC, animated: true, completion: nil)
                    
                }, failure: { (code, data) in
                    //self.failure(code!, data: data!)
                }, complete: nil)
  
    }

}
