//
//  AddNewPlayerTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/4/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SDWebImage

class AddNewPlayerTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var team = Team()
    var searchController: UISearchController!
    var searchResults: [Player] = []
    let playerListTableViewCell = "PlayerListTableViewCell"
    var isInListingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.registerNib(UINib(nibName: playerListTableViewCell, bundle: nil), forCellReuseIdentifier: playerListTableViewCell)
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
        if searchController.active {
            return searchResults.count
        }else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(playerListTableViewCell, forIndexPath: indexPath) as! PlayerListTableViewCell

        
        let player = searchResults[indexPath.row]
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
        
        let player = searchResults[indexPath.row]
        
//        if isInListingMode {
//
//            self.team.players.append(player)
//            self.navigationController?.popViewControllerAnimated(true)
//        }else{
//        }
        HttpManager.sharedInstance.request(HttpMethod.HttpMethodPatch,
                                           apiFunc: APiFunction.AddPlayersInTeam,
                                           param: ["auth_token": CurrentUser.sharedInstance.authToken!,
                                            ":id" : team.teamId!,
                                            "added_user_ids" : [player.playerId!]],
                                           success: { (code, data) in
                                            
                                            self.team.players.append(player)
                                            self.navigationController?.popViewControllerAnimated(true)
            }, failure: { (code, data) in
                //failure
                print("error: \(data)")
                
            }, complete: nil)

    }

    func filterContentForSearchText(searchText: String ) {
        
        HttpManager.sharedInstance.request(HttpMethod.HttpMethodGet,
                                           apiFunc: APiFunction.SearchUser,
                                           param: ["search" : searchText ],
                                           success: { (code, data) in
                                            self.searchResults.removeAll()
                                            
                                            for member in data["results"].arrayValue{
                                                
                                                let searchMember = Player()
                                                searchMember.playerId = member["id"].stringValue
                                                searchMember.playerImageUrl = member["photo"].stringValue
                                                searchMember.playerName = member["username"].stringValue
                                                self.searchResults.append(searchMember)
                                            }
                                            self.tableView.reloadData()
                                            
            }, failure: { (code, data) in
                //failure
                print("error: \(data)")
               
            }, complete: nil)
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }

}
