//
//  Teams.swift
//  MyScoreBoardapp
//
//  Created by stephanie yang on 2016/5/2.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

import Foundation


class Teams{
    var teams = [Team]()
   
    static let sharedInstance = Teams()
    
    private init() {}
    
    
    func addTeam(team:Team)  {
        teams.append(team)
    }
    
    func removeAllTeams() {
        teams.removeAll()
    }
    
    func updateTeam(updatedTeam:Team) {
        
        for team in teams {
            
            if (team.TeamId! == updatedTeam.TeamId!) {
                team.players = updatedTeam.players
            }
        }
    }
    
    func deleteTeam(teamToDelete:Team) {
        
        var position = -1;
        
        for (index,team) in teams.enumerate() {
            
            if (team.TeamId! == teamToDelete.TeamId!) {
                position = index
                break
            }
        }
        
        if position != -1 {
            teams.removeAtIndex(position)
        }
        
    }
    
}

