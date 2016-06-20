//
//  ForgetPasswordViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/20/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sentPressed(sender: AnyObject) {
        
        HttpManager.sharedInstance
            .request(HttpMethod.HttpMethodPost,
                     apiFunc: APiFunction.ResetPassword,
                     param: [
                        "email": emailTextField.text!],
                     success: { (code , data ) in
                     let alertController = UIAlertController(title: "重設密碼郵件已送出", message: "", preferredStyle: .Alert)
                        
                     let alertAction = UIAlertAction(title: "OK", style: .Default, handler: { UIAlertAction in
                        self.dismissViewControllerAnimated(true, completion: nil)
                     })
                     alertController.addAction(alertAction)
                     self.presentViewController(alertController, animated: true, completion: nil)
                },
                     failure: { (code , data) in
                        print("failed with \(code), \(data)")
                        let alertController = UIAlertController(title: "email不正確", message: "請確認是否已註冊myscoreboard", preferredStyle: .Alert)
                        
                        let alertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                },
                     complete: nil)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
