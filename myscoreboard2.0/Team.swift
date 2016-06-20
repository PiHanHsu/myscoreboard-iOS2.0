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
    var teamName:String?
    var gameTimeDay:String?
    var gameTimeHour:String?
    var GameLocation:String?
    var teamId:String?
    
    init(data:JSON) {
        self.TeamImageUrl = data["team"]["logo_original_url"].stringValue
        self.teamName = data["team"]["name"].stringValue
        self.gameTimeDay = data["team"]["day"].stringValue
        self.gameTimeHour = (data["team"]["start_time_hour"].stringValue)+":"+(data["team"]["start_time_min"].stringValue)+"-"+(data["team"]["end_time_hour"].stringValue)+":"+(data["team"]["end_time_min"].stringValue)

        self.GameLocation = data["team"]["location"]["place_name"].stringValue
        self.teamId = data["team"]["id"].stringValue
        
        for member in data["team"]["teammembers"].arrayValue {
            let newPlayer = Player()
            let playerData = member.dictionary!
            
            newPlayer.playerName = playerData["username"]?.stringValue
            newPlayer.playerId = playerData["id"]?.stringValue
            newPlayer.gender = playerData["gender"]?.stringValue
            newPlayer.playerImageUrl = playerData["photo"]?.stringValue
            
            self.players.append(newPlayer)
        }
        
        
      }
    
    override init() {
        
    }
    

}