//
//  MatchList.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/15/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation

class MatchList {
    
    static let shareInstance = MatchList()
    //private init() {}
    
    var matchesList: Array<Match>?
    
    
    func getMatchesList(players: Array<Player>) -> [Match]?{
        var malePlayerArray = [Player]()
        var femalePlayerArray = [Player]()
        
        var mixMatches = [Match]()
        var maleDoublesMatches = [Match]()
        var femaleDoublesMatches = [Match]()
        
        for player in players {
            if player.gender == "male" {
                malePlayerArray.append(player)
            }else{
                femalePlayerArray.append(player)
            }
        }
        
        // mix pairs
        if malePlayerArray.count >= 2 && femalePlayerArray.count >= 2 {
            
            var mixPairs = [Pair]()
            for malePlayer in malePlayerArray{
                for femalePlayer in femalePlayerArray {
                    let pair = Pair()
                    pair.player1 = malePlayer
                    pair.player2 = femalePlayer
                    mixPairs.append(pair)
                }
            }
            mixMatches = generateMatches(mixPairs)
        }
        
        // male doubles pairs
        
        if malePlayerArray.count >= 4 {
            var maleDoublesPairs = [Pair]()
            
            for (index, malePlayer1) in malePlayerArray.enumerate() {
                for malePlayer2 in malePlayerArray[index + 1 ..< malePlayerArray.count] {
                    let pair = Pair()
                    pair.player1 = malePlayer1
                    pair.player2 = malePlayer2
                    maleDoublesPairs.append(pair)
                }
            }
            
            maleDoublesMatches = generateMatches(maleDoublesPairs)
        }
        
        
        // female doubles pairs
        if femalePlayerArray.count >= 4 {
            var femaleDoublesPairs = [Pair]()
            
            for (index, femalePlayer1) in femalePlayerArray.enumerate() {
                for femalePlayer2 in femalePlayerArray[index + 1 ..< femalePlayerArray.count] {
                    let pair = Pair()
                    pair.player1 = femalePlayer1
                    pair.player2 = femalePlayer2
                    femaleDoublesPairs.append(pair)
                }
            }
            
            femaleDoublesMatches = generateMatches(femaleDoublesPairs)
        }
        
        matchesList = mixMatches + maleDoublesMatches + femaleDoublesMatches
        
        if matchesList?.isEmpty == false {
           matchesList = matchesList!.shuffle()
        }
        
        return matchesList
    }
    
    func generateMatches(pairs: [Pair]) -> [Match] {
        var matches = [Match]()
        
        for (index, pair1) in pairs.enumerate() {
            for pair2 in pairs[index + 1 ..< pairs.count] {
                var match = Match()
                if pair1.player1 != pair2.player1 && pair1.player1 != pair2.player2 && pair1.player2 != pair2.player1 && pair1.player2 != pair2.player2 {
                    match.pair1 = pair1
                    match.pair2 = pair2
                    matches.append(match)
                }
            }
        }
        return matches
    }
    
}