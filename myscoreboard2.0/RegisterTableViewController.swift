//
//  RegisterTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 5/17/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    
    var blackBackGround = UIView()
    var pickerViewHeaderView = UIView()
    var pickerBackgroundView = UIView()
    
    var email:String?
    var password:String?
    var gender:String?
    var pickerContent:[String] = ["男", "女"]
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarView.backgroundColor = UIColor.mainBlueColor()
        self.userPhotoImageView.layer.cornerRadius = 50.0
        self.userPhotoImageView.clipsToBounds = true
        imagePicker.delegate = self
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
        //設定每個header的高度
        return 20
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            genderPicker.delegate = self
            genderPicker.dataSource = self
            
            self.blackBackGround = UIView(frame: CGRect(x: 0, y: 0 , width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height * 7/10 ))
            self.blackBackGround.backgroundColor = UIColor.blackColor()
            self.blackBackGround.alpha = 0.5
            self.view.addSubview(self.blackBackGround)
            
            
            pickerViewHeaderView.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height * 7/10 , width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height * 1/10 )
            pickerViewHeaderView.backgroundColor = UIColor.whiteColor()
            let headerTitleLabel = UILabel()
            headerTitleLabel.text = "選擇性別"
            headerTitleLabel.textColor = UIColor.blackColor()
            headerTitleLabel.frame = CGRect(x: 0, y: 0 , width: 75, height: 21 )
            headerTitleLabel.center = CGPoint(x: UIScreen.mainScreen().bounds.width * 0.5, y: UIScreen.mainScreen().bounds.height * 0.05)
            pickerViewHeaderView.addSubview(headerTitleLabel)
            self.view.addSubview(pickerViewHeaderView)
            
            pickerBackgroundView.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height * 8/10 , width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height * 2/10 )
            pickerBackgroundView.backgroundColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1)
            self.view.addSubview(pickerBackgroundView)
            
            genderPicker.frame =  CGRect(x: 0, y: UIScreen.mainScreen().bounds.height * 8/10 , width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height * 2/10 )
            self.view.addSubview(genderPicker)

        }
    }
   
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        
        let userName = nickNameTextField.text!.trim()
        email = emailTextField.text!.trim()
        password = passwordTextField.text!.trim()
        
        
        HttpManager.sharedInstance
            .request(
                HttpMethod.HttpMethodPost,
                apiFunc: APiFunction.Register,
                param: [
                    "username" : userName,
                    "email": email!,
                    "password": password!,
                    "gender" : gender! ],
                success: { (code, data ) in
                    print("account created!!")
                    self.success(code, data: data)
                }, failure: { (code, data) in
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
    
    // MARK: - UIPickerViewDataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerContent[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row
        {
        case 0:
            gender = Gender.male;
        case 1:
            gender = Gender.female;
        default:
            break;
        }
        genderLabel.text = pickerContent[row]
        dismissPickerView()
    }
    
    func dismissPickerView() {
        genderPicker.removeFromSuperview()
        blackBackGround.removeFromSuperview()
        pickerViewHeaderView.removeFromSuperview()
        pickerBackgroundView.removeFromSuperview()
    }
    
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: { cameraAction in
            
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .Camera
                self.imagePicker.cameraCaptureMode = .Photo
                self.imagePicker.modalPresentationStyle = .FullScreen
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            } else {
                self.noCamera()
            }
            
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let albumAction = UIAlertAction(title: "Photo Album", style: .Default, handler: { albumAction in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)

            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { defaultAction in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPhotoImageView.contentMode = .ScaleAspectFill
            userPhotoImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
