//
//  RegisterTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/17/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterTableViewController: MyScoreBoardEditInfoTableViewController {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    var email:String?
    var password:String?
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
        self.navBarView.backgroundColor = UIColor.mainBlueColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        default:
            0
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            selectGender()
        }
    }
   
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        
        let userName = nickNameTextField.text!.trim()
        email = emailTextField.text!.trim()
        password = passwordTextField.text!.trim()
        
        indicator.startAnimating()
        if photoImageView.image != nil {
            let path = "https://product.myscoreboardapp.com/api/v1/signup"
        
            HttpManager.sharedInstance.uploadDataWithImage(HttpMethod.HttpMethodPost,
                                                           path: path,
                                                           uploadImage: photoImageView.image!,
                                                           imageParam: "head",
                                                           param:  [
                                                            "username" : userName,
                                                            "email": email!,
                                                            "password": password!,
                                                            "gender" : gender!,],
                                                           success: { (code, data) in
                                                            print("signup user with image success")
                                                            self.success(code, data: data)
                                                            
                }, failure: { (code, data) in
                    print("signup user with image failed: \(data)")
                    
                }, complete: nil)
        }else{
            
            HttpManager.sharedInstance
                .request(
                    HttpMethod.HttpMethodPost,
                    apiFunc: APiFunction.Register,
                    param: [
                        "username" : userName,
                        "email": email!,
                        "password": password!,
                        "gender" : gender!],
                    success: { (code, data ) in
                        print("account created!!")
                        self.success(code, data: data)
                       
                    }, failure: { (code, data) in
                        print("signup user without image failed: \(data)")
                        //self.failure(code!, data: data!)
                    }, complete: nil)

        }
    }
    
    func success(code:Int, data:JSON ) {
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPost,
                apiFunc: APiFunction.Login,
                param: ["email": email!,
                    "password": password!],
                success: { (code, data ) in
                    //save token to userDefault
                    let token = data["auth_token"].stringValue
                    let userId = data["user_id"].stringValue
                    let username = data["username"].stringValue
                    let gender = data["gender"].stringValue
                    let photo = data["photo"].stringValue
                    let email = data["email"].stringValue
                    
                    let userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setObject(token, forKey: "auth_token")
                    userDefault.setObject(userId, forKey: "user_id")
                    userDefault.setObject(username, forKey: "username")
                    userDefault.setObject(gender, forKey: "gender")
                    userDefault.setObject(photo, forKey: "photo")
                    userDefault.setObject(email, forKey: "email")
                    
                    userDefault.synchronize()
                    
                    print("userDefault.token: \(token)")
                    
                    self.setCurrentUser()

                }, failure: { (code, data) in
                    
                  print("login failed: \(data)")
                   //self.failure(code!, data: data!)
                }, complete: nil)
    }
    
    func failure(code:Int, data:JSON ) {
        print("sign up failed: \(data)")
        self.indicator.stopAnimating()

        let message = data["message"].stringValue
        let alertController = UIAlertController(title: "登入失敗!", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setCurrentUser() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        CurrentUser.sharedInstance.authToken = userDefault.stringForKey("auth_token")
        CurrentUser.sharedInstance.userId = userDefault.stringForKey("user_id")
        CurrentUser.sharedInstance.username = userDefault.stringForKey("username")
        CurrentUser.sharedInstance.gender = userDefault.stringForKey("gender")
        CurrentUser.sharedInstance.photo_url = userDefault.stringForKey("photo")
        CurrentUser.sharedInstance.email = userDefault.stringForKey("email")
        
        self.performSegueWithIdentifier("Show main page", sender: self)
        
    }


}
