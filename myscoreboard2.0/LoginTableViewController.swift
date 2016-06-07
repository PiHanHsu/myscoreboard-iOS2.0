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
    
    @IBOutlet weak var loginButton: UIButton!
    var headerHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.mainBlueColor()
        if self.view.frame.size.height == 480 {
            headerHeight = self.view.frame.size.height - 50 - 44 - 44 - 64
        }else {
            headerHeight = self.view.frame.size.height - 50 - 44 - 44 - 44 - 64
        }
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight!)
        self.footerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50 )
        self.footerView.backgroundColor = UIColor(red: 0.0/255.0, green: 159.0/255.0, blue: 214.0/255.0, alpha: 1)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"信箱",
                                                                       attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"密碼",
                                                                          attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        
        self.loginButton.backgroundColor = UIColor.mainYellowColor()
        self.loginButton.layer.cornerRadius = 5.0
        self.loginButton.clipsToBounds = true
        
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
        if self.view.frame.size.height == 480 {
            return 3
        }else {
            return 4
        }
        
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
        
        //haven't test from FBLogin
        print(data)
        
        
        //save token to userDefault
        
        CurrentUser.sharedInstance.authToken = data["auth_token"].stringValue
        CurrentUser.sharedInstance.userId = data["user_id"].stringValue
        CurrentUser.sharedInstance.username = data["username"].stringValue
        CurrentUser.sharedInstance.gender = data["gender"].stringValue
        CurrentUser.sharedInstance.photo_url = data["photo"].stringValue
        
        let token:String = data["auth_token"].stringValue
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(token, forKey: "token")
        userDefault.synchronize()
        
        loadData()
        
    }
    
    func failure(code:Int, data:JSON ) {
        //print(data)
        
        let message = data["message"].stringValue
        let alertController = UIAlertController(title: "登入失敗!", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        print("validate : \(emailStr)")
        let emailRegEx = Params.emailReg
        let range = emailStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        return range != nil
    }
    
    func isValidpassword(passwordStr:String) -> Bool {
        print("validate : \(passwordStr)")
        let passwordRegEx = Params.passwordReg
        let range = passwordStr.rangeOfString(passwordRegEx, options:.RegularExpressionSearch)
        return range != nil
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        let email = emailTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let password = passwordTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        //check email and password
        if self.isValidEmail(email) && self.isValidpassword(password){
            HttpManager.sharedInstance
                .request(
                    HttpMethod.HttpMethodPost,
                    apiFunc: APiFunction.Login,
                    param: ["email": email,
                        "password": password],
                    success: { (code, data ) in
                        self.success(code, data: data)
                    }, failure: { (code, data) in
                        //self.failure(code!, data: data!)
                    }, complete: nil)
        }else{
            //alert
            let alertController = UIAlertController(title: "注意!", message: "email 或 密碼格式不對", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func loadData() {
        HttpManager.sharedInstance
            .request(HttpMethod.HttpMethodGet,
                     apiFunc: APiFunction.GetTeamList,
                     param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
                        ":user_id": CurrentUser.sharedInstance.userId!],
                     success: { (code , data ) in
                        //print(data)
                        for team in data["results"].arrayValue {
                            Teams.sharedInstance.teams.append(Team(data: team))
                        }
                        //go to main page
                        self.performSegueWithIdentifier("Show main page", sender: self)
                },
                     failure: { (code , data) in
                        self.failure(code!, data: data!)
                },
                     complete: nil)
        
    }
    
}
