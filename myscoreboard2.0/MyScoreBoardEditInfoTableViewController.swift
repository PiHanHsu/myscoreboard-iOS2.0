//
//  MyScoreBoardEditInfoTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/8/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class MyScoreBoardEditInfoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    let imagePicker = UIImagePickerController()
    var gender:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        photoImageView.layer.cornerRadius = 50.0
        photoImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            photoImageView.contentMode = .ScaleAspectFill
            photoImageView.image = pickedImage
        }
        
        //let image_data = UIImagePNGRepresentation(photoImageView.image!)
        
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
    
    //select gender
    func selectGender() {
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .ActionSheet)
        
        let maleAlertAction = UIAlertAction(title: "男", style: .Default, handler: {
            maleAlertAction in
            self.gender = Gender.male
            self.genderLabel.text = "男"
        })
        let femaleAlertAction = UIAlertAction(title: "女", style: .Default, handler: {
            femaleAlertAction in
            self.gender = Gender.female
            self.genderLabel.text = "女"
        })
        
        alertController.addAction(maleAlertAction)
        alertController.addAction(femaleAlertAction)
        
        presentViewController(alertController, animated: true, completion:nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
