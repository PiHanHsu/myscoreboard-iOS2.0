//
//  Team.swift
//  MyScoreBoardapp
//
//  Created by stephanie yang on 2016/4/30.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

import Foundation
import SwiftyJSON
class Team: NSObject {
    
    var players = [Player]()
    var TeamImageUrl:String?
    var TeamName:String?
    var GameTimeDay:String?
    var GameTimeHour:String?
    var GameLocation:String?
    var TeamId:String?
    
    init(data:JSON) {
        self.TeamImageUrl = data["team"]["logo_original_url"].stringValue
        self.TeamName = data["team"]["name"].stringValue
        self.GameTimeDay = data["team"]["day"].stringValue
        self.GameTimeHour = (data["team"]["start_time_hour"].stringValue)+":"+(data["team"]["start_time_min"].stringValue)+"-"+(data["team"]["end_time_hour"].stringValue)+":"+(data["team"]["end_time_min"].stringValue)

        self.GameLocation = data["team"]["location"]["place_name"].stringValue
        self.TeamId = data["team"]["id"].stringValue
        
        for member in data["teammates"].arrayValue {
            let newPlayer = Player()
            let playerData = member.dictionary!
            
            //print(member)
            //print(playerData["id"])
 
            newPlayer.playerName = playerData["username"]?.stringValue
            newPlayer.playerId = playerData["id"]?.stringValue
            newPlayer.playerImageUrl = playerData["user_photo"]?.stringValue
            //print(playerData["user_photo"])
            self.players.append(newPlayer)
        }
        
        
      }
    
    override init() {
        
    }
    

}