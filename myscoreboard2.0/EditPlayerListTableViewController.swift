//
//  EditPlayerListTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/5/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SDWebImage

class EditPlayerListTableViewController: UITableViewController {
    
    var team = Team()
    var isEditMode = false
    let playerListTableViewCell = "PlayerListTableViewCell"

   
    @IBOutlet var cancelBarButton: UIBarButtonItem!
    
    
    @IBOutlet var deleteBarButton: UIBarButtonItem!
    
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    @IBOutlet var editBarButton: UIBarButtonItem!
    
    @IBOutlet var backBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 56
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: playerListTableViewCell, bundle: nil), forCellReuseIdentifier: playerListTableViewCell)
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        updateButtonsToMatchTableState()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
        return team.players.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(playerListTableViewCell, forIndexPath: indexPath) as! PlayerListTableViewCell
        
        let player = team.players[indexPath.row]
        cell.nameLabel.text = player.playerName
        
        
        if let imageUrl = player.playerImageUrl {
            if imageUrl != "" {
                cell.photoImageView.sd_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: nil, options: SDWebImageOptions.RetryFailed)
            }
        }else{
            cell.photoImageView.image = UIImage()
        }
        return cell

    }
    

    @IBAction func cancelAction(sender: AnyObject) {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }
    
    
    @IBAction func backAction(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        
        tableView.setEditing(true, animated: true)
        updateButtonsToMatchTableState()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    @IBAction func deleteAction(sender: AnyObject) {
    }
    
    func updateButtonsToMatchTableState() {
        
        if self.tableView.editing
        {
            navigationItem.leftBarButtonItem = cancelBarButton
            navigationItem.rightBarButtonItems = [deleteBarButton]
            
        }
        else
        {
            navigationItem.leftBarButtonItem = backBarButton
            navigationItem.rightBarButtonItems = [addBarButton, editBarButton]
            
            if team.players.count > 0
            {
                self.editBarButton.enabled = true
            }
            else
            {
                self.editBarButton.enabled = false
            }
           
        }

    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func addButtonPressed(sender: AnyObject) {
  performSegueWithIdentifier("GoToAddPlayerPage", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToAddPlayerPage" {
            let vc = segue.destinationViewController as! AddNewPlayerTableViewController
            vc.team = team
            vc.isInListingMode = true
        }
    }


}
