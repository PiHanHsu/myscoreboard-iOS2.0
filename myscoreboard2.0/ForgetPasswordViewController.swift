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
                        print("success")
                },
                     failure: { (code , data) in
                        print("failed with \(code), \(data)")
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
