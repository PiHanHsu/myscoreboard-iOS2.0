//
//  SearchLocationTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/5/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchLocationTableViewController: UITableViewController , UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var searchResults: [JSON] = []
    var place = Place?()
    var team = Team()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
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
        return searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = searchResults[indexPath.row]["description"].stringValue
        
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let placeId = searchResults[indexPath.row]["place_id"].stringValue
        
        HttpManager.sharedInstance.request(HttpMethod.HttpMethodGet,
                                           apiFunc: APiFunction.GooglePlaceDetail,
                                           param: ["placeid" : placeId,
                                                     "key" : Params.googlePlaceApiKey],
                                           success: { (code, data) in
                                            //print(data)
                                            let name = data["result"]["name"].stringValue
                                            let lat = data["result"]["geometry"]["location"]["lat"].doubleValue
                                            let lng = data["result"]["geometry"]["location"]["lng"].doubleValue
                                            let address = data["result"]["formatted_address"].stringValue
                                            self.team.place = Place(placeId: placeId, name: name, latitude: lat, longitude: lng, address: address)
                                            self.navigationController?.popViewControllerAnimated(true)
                                            
            }, failure: { (code, data) in
                
            }, complete: nil)

    }
    
    // for search
    func filterContentForSearchText(searchText: String ) {
        
        HttpManager.sharedInstance.request(HttpMethod.HttpMethodGet,
                                           apiFunc: APiFunction.GooglePlaceAutoComplete,
                                           param: ["input" : searchText,
                                                     "key" : Params.googlePlaceApiKey],
                                           success: { (code, data) in
                                            //print(data)
                                            self.searchResults = data["predictions"].arrayValue
                                            self.tableView.reloadData()
            }, failure: { (code, data) in
                
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
