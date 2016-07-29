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
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.stringForKey("auth_token") != nil {
            indicator.startAnimating()
            setCurrentUser()
        }
        
        // setup layout
        self.tableView.backgroundColor = UIColor.mainBlueColor()
        if self.view.frame.size.height == 480 {
            headerHeight = self.view.frame.size.height - 50 - 44 - 44 - 64
        }else {
            headerHeight = self.view.frame.size.height - 50 - 44 - 44 - 44 - 64
        }
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight!)
        self.footerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50 )
        self.footerView.backgroundColor = UIColor(red: 89.0/255.0, green: 212.0/255.0, blue: 255.0/255.0, alpha: 1)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Internet ReachAbility
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenReachable = { reachability in
            
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
            }
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.view.frame.size.height == 480 {
            return 3
        }else {
            return 4
        }
    }
    
    @IBAction func fbLogin(sender: AnyObject) {
        indicator.startAnimating()
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookresult, facebookError) -> Void in
            
            if facebookError != nil {
                print("FaceBook login failed. Error: \(facebookError)")
                self.indicator.stopAnimating()
            }else if facebookresult.isCancelled{
                print("Facebook login was cancelled.")
                self.indicator.stopAnimating()
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                //print(accessToken)
                
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
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        indicator.startAnimating()
        
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
                        print("failed")
                        self.failure(code!, data: data!)
                    }, complete: nil)
        }else{
            indicator.stopAnimating()
            //alert
            let alertController = UIAlertController(title: "注意!", message: "email 或 密碼格式不對", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // login call back
    func success(code:Int, data:JSON ) {
        
        //print(data)
        
        //save user to userDefault
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
        
        //print("userDefault.token: \(token)")
        
        setCurrentUser()
        
    }
    
    func failure(code:Int, data:JSON ) {
        
        let message = data["message"].stringValue
        let alertController = UIAlertController(title: "登入失敗!", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        indicator.stopAnimating()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // set current user
    
    func setCurrentUser() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        CurrentUser.sharedInstance.authToken = userDefault.stringForKey("auth_token")
        print("token: \( CurrentUser.sharedInstance.authToken)")
        
        CurrentUser.sharedInstance.userId = userDefault.stringForKey("user_id")
        CurrentUser.sharedInstance.username = userDefault.stringForKey("username")
        CurrentUser.sharedInstance.gender = userDefault.stringForKey("gender")
        CurrentUser.sharedInstance.photo_url = userDefault.stringForKey("photo")
        CurrentUser.sharedInstance.email = userDefault.stringForKey("email")
        
        GlobalFunction.sharedInstance.reloadDataFromServer({
            
            self.indicator.startAnimating()
            //go to main page
            self.performSegueWithIdentifier("Show main page", sender: self)
        })
    }
    
    // validate email and password
    
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

}

extension LoginTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
}
