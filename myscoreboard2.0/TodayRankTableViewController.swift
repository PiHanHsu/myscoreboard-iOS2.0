//
//  TodayRankTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/15/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SwiftyJSON
import UXTesting

class TodayRankTableViewController: UITableViewController {
    
    let gameTableViewCell = "GameTableViewCell"
    let team = Teams.sharedInstance.currentPlayingTeam
    var gameData: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: gameTableViewCell, bundle: nil), forCellReuseIdentifier: gameTableViewCell)
        self.tableView.registerNib(UINib(nibName: "SingleGameTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleGameTableViewCell")
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(TodayRankTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
        
        loadingData()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        UXTestingManager.sharedInstance().heatMapStartWithViewName("Today's Rank Page")
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
        
        return gameData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let oneGameData = gameData[indexPath.row]["game"]
        
        if oneGameData.count == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SingleGameTableViewCell", forIndexPath: indexPath) as! SingleGameTableViewCell
            
            cell.team1Player1NameLabel.text = oneGameData[0]["username"].stringValue
            
            cell.team2Player1NameLabel.text = oneGameData[1]["username"].stringValue
            
            if oneGameData[0]["score"].intValue > oneGameData[1]["score"].intValue {
                cell.team1ScoreLabel.textColor = UIColor.redColor()
            }else {
                cell.team2ScoreLabel.textColor = UIColor.redColor()
            }
            cell.team1ScoreLabel.text = oneGameData[0]["score"].stringValue
            cell.team2ScoreLabel.text = oneGameData[1]["score"].stringValue
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(gameTableViewCell, forIndexPath: indexPath) as! GameTableViewCell
            cell.team1Player1NameLabel.text = oneGameData[0]["username"].stringValue
            cell.team1Player2NameLabel.text = oneGameData[1]["username"].stringValue
            cell.team2Player1NameLabel.text = oneGameData[2]["username"].stringValue
            cell.team2Player2NameLabel.text = oneGameData[3]["username"].stringValue
            if oneGameData[0]["score"].intValue > oneGameData[2]["score"].intValue {
                cell.team1ScoreLabel.textColor = UIColor.redColor()
            }else {
                cell.team2ScoreLabel.textColor = UIColor.redColor()
            }
            cell.team1ScoreLabel.text = oneGameData[0]["score"].stringValue
            cell.team2ScoreLabel.text = oneGameData[2]["score"].stringValue
            
            return cell
            
        }
        
    }
    
    func refresh(sender:AnyObject) {
        loadingData()
    }
    
    func loadingData() {
        
        HttpManager.sharedInstance
            .request(HttpMethod.HttpMethodPost,
                     apiFunc: APiFunction.GetTodayGames,
                     param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
                        "team_id": team.teamId!],
                     success: { (code , data ) in
                        //print(data)
                        self.gameData = data["result"]["today_games"]
                        //print("count: \(self.gameData.count)")
                        //print(self.gameData)
                        self.refreshControl!.endRefreshing()
                        self.tableView.reloadData()
                },
                     failure: { (code , data) in
                        self.refreshControl!.endRefreshing()
                        print("failed with \(code), \(data)")
                },
                     complete: nil)
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
    
}
