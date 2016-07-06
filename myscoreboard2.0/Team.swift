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
    var gameDay:String?
    var gameStartTime: String?
    var gameEndTime: String?
    
    var gameTimeHour:String?
    var gameLocation:String?
    
    var teamId:String?
    var place: Place?
    
    init(data:JSON) {
        self.TeamImageUrl = data["team"]["logo_original_url"].stringValue
        self.teamName = data["team"]["name"].stringValue
        self.gameDay = data["team"]["day"].stringValue
        self.gameStartTime = data["team"]["start_time_hour"].stringValue + ":" + data["team"]["start_time_min"].stringValue
        self.gameEndTime = data["team"]["end_time_hour"].stringValue + ":" + data["team"]["end_time_min"].stringValue
        
        self.gameTimeHour = self.gameStartTime! + " ~ " + self.gameEndTime!
        
        self.place?.name = data["team"]["location"]["place_name"].stringValue
        
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