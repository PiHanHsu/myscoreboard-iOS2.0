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
    @IBOutlet var createAccountButton: UIButton!
    
    var email:String?
    var password:String?
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
        self.navBarView.backgroundColor = UIColor.mainBlueColor()
        //createAccountButton.enabled = false
        nickNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
        
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
        
        let (readyToCreate, message) = checkSentButtonEnable()
        
        if readyToCreate {
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

        }else {
            indicator.stopAnimating()
            let alert = UIAlertController(title: "注意", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (_) in
                
            })
            
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            
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

extension RegisterTableViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
//        if checkSentButtonEnable() {
//           createAccountButton.enabled = true
//        }else {
//           createAccountButton.enabled = false
//        }
        
        return true
    }
    
    func checkSentButtonEnable() -> (readyToCreate: Bool, message: String) {
        //var enable = false
        let textFieldArray = [nickNameTextField, emailTextField, passwordTextField, retypePasswordTextField ]
        
        for textField in textFieldArray {
            guard textField.text != nil else {
                return (false, "有欄位尚未填寫")
            }
        }
        
        guard nickNameTextField.text?.characters.count > 0 else {
            return (false, "暱稱不可為空白")
        }
        
        guard genderLabel.text != "請選擇性別" else {
            return (false, "請選擇性別")
        }
        
        guard isValidpassword(emailTextField.text!) else {
            return (false, "Email格式錯誤")
        }
        
        guard isValidpassword(passwordTextField.text!) else {
            return (false, "密碼格式錯誤")
        }
        
        guard passwordTextField.text == retypePasswordTextField.text else {
            return (false, "密碼不相同, 請重新輸入密碼！")
        }
        
        return (true, "ready")

    }
    
    // validate email and password
    
    func isValidEmail(emailStr:String) -> Bool {
        
        let emailRegEx = Params.emailReg
        let range = emailStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        return range != nil
    }
    
    func isValidpassword(passwordStr:String) -> Bool {
        
        let passwordRegEx = Params.passwordReg
        let range = passwordStr.rangeOfString(passwordRegEx, options:.RegularExpressionSearch)
        return range != nil
    }
    
}







