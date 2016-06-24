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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        var photoString = ""
        if (photoImageView.image != nil) {
          let imageData = UIImagePNGRepresentation(photoImageView.image!);
          photoString = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
          print("got photo string")
        }
        print(photoString)
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPost,
                apiFunc: APiFunction.Register,
                param: [
                    "username" : userName,
                    "email": email!,
                    "password": password!,
                    "gender" : gender!,
                    "head" : photoString ],
                success: { (code, data ) in
                    print("account created!!")
                    self.success(code, data: data)
                }, failure: { (code, data) in
                    print(data)
                    //self.failure(code!, data: data!)
                }, complete: nil)
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
                    
                    let token:String = data["auth_token"].stringValue
                    let userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setObject(token, forKey: "token")
                    userDefault.synchronize()
                    
                    //go to main page
                    self.performSegueWithIdentifier("Go to main page", sender: self)
                }, failure: { (code, data) in
                   //self.failure(code!, data: data!)
                }, complete: nil)
    }
    
    func failure(code:Int, data:JSON ) {
        print("\(#function)")
        print(code)
        print(data)
        
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
    

}
