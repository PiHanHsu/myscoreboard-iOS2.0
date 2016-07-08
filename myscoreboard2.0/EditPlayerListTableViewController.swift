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
    let playerListTableViewCell = "PlayerListTableViewCell"
    var selectedPlayersToDelete = [String]()
   
    @IBOutlet var cancelBarButton: UIBarButtonItem!
    @IBOutlet var deleteBarButton: UIBarButtonItem!
    @IBOutlet var addBarButton: UIBarButtonItem!
    @IBOutlet var editBarButton: UIBarButtonItem!

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    // Bar Button Action

    @IBAction func cancelAction(sender: AnyObject) {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }

    @IBAction func editButtonPressed(sender: AnyObject) {
        tableView.setEditing(true, animated: true)
        updateButtonsToMatchTableState()
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        let selectedRows = tableView.indexPathsForSelectedRows
        
        if selectedRows != nil && selectedRows!.count > 0{
            for indexPath in selectedRows! {
                let player = team.players[indexPath.row]
                selectedPlayersToDelete.append(player.playerId!)
            }
            
            HttpManager.sharedInstance.request(HttpMethod.HttpMethodPatch,
                                               apiFunc: APiFunction.RemovePlayerInTeam,
                                               param: ["auth_token": CurrentUser.sharedInstance.authToken!,
                                                ":id" : team.teamId!,
                                                "removed_user_ids" : selectedPlayersToDelete ]
                , success: { (code, data) in
                    print("remove players success")
                    for indexPath in selectedRows! {
                        let player = self.team.players[indexPath.row]
                        print(player.playerName!)
                        self.team.players.removeAtIndex(self.team.players.indexOf(player)!)
                    }
                    self.reloadDataFromServer()
                }, failure: { (code, data) in
                    print("update team info failed: \(data)")
            })
        }else {
            
        }
        
        
        
        print(selectedPlayersToDelete)
        
        updateButtonsToMatchTableState()
    }
    
    func updateButtonsToMatchTableState() {
        
        if self.tableView.editing
        {
            navigationItem.leftBarButtonItem = cancelBarButton
            navigationItem.rightBarButtonItems = [deleteBarButton]
        }
        else
        {
            navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
            navigationItem.rightBarButtonItems = [addBarButton, editBarButton]
            
            if team.players.count > 0 {
                self.editBarButton.enabled = true
            }else {
                self.editBarButton.enabled = false
            }
        }
    }
    
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
        
        func reloadDataFromServer() {
            HttpManager.sharedInstance
                .request(HttpMethod.HttpMethodGet,
                         apiFunc: APiFunction.GetTeamList,
                         param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
                            ":user_id": CurrentUser.sharedInstance.userId!],
                         success: { (code , data ) in
                            for team in data["results"].arrayValue {
                                Teams.sharedInstance.teams.append(Team(data: team))
                            }
                            self.tableView.reloadData()
                            self.tableView.setEditing(false, animated: true)
                            self.updateButtonsToMatchTableState()
                    
                    },
                         failure: { (code , data) in
                            
                    },
                         complete: nil)
            
        }


}
