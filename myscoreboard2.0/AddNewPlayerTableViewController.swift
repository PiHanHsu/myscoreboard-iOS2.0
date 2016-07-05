//
//  AddNewPlayerTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/4/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class AddNewPlayerTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var team = Team()
    var searchController: UISearchController!
    var searchResults: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active {
            return searchResults.count
        }else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = searchResults[indexPath.row].playerName

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func filterContentForSearchText(searchText: String ) {
        
        HttpManager.sharedInstance.request(HttpMethod.HttpMethodGet,
                                           apiFunc: APiFunction.SearchUser,
                                           param: ["search" : searchText ],
                                           success: { (code, data) in
                                            
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
                print("search faileds")
            }, complete: nil)
        
        
        searchResults = team.players.filter({ (Player) -> Bool in
            let nameMatch = Player.playerName?.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }

}
