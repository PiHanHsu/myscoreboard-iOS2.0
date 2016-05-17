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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var headerHeight:CGFloat {
        get {
           return UIScreen.mainScreen().bounds.height * 0.66
        }
    }
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
                            print("success")
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
        
        //haven't test from FBLogin
        
        
        
        //save token to userDefault
        
        let token:String = data["auth_token"].stringValue
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(token, forKey: "token")
        userDefault.synchronize()
        
        //go to main page
        self.performSegueWithIdentifier("Show main page", sender: self)
    }
    
    func failure(code:Int, data:JSON ) {
        print("\(#function)")
        print(code)
        print(data)
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
    
        let email = emailTextField.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let password = passwordTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPost,
                apiFunc: APiFunction.Login,
                param: ["email": email,
                        "password": password],
                success: { (code, data ) in
                    self.success(code, data: data)
                }, failure: { (code, data) in
                    self.failure(code!, data: data!)
                }, complete: nil)

        
    }
    
}
