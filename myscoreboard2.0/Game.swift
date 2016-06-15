//
//  Game.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 5/7/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class Game {
    static let shareInstance = Game()
    
    var teamId:Int = 0
    var gamePlayers:[Player] = []
    var matchesList = [Match]()
    var numberOfGuestPlayer:Int = 0
    var gameMode:String = ""
    var playerM:[String:Int] = [:]
    var playerF:[String:Int] = [:]
    
    func getMatchesList(players: Array<Player>) -> [Match]{
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
        return matchesList
    }
    
    func generateMatches(pairs: [Pair]) -> [Match] {
        var matches = [Match]()
        
        for (index, pair1) in pairs.enumerate() {
            for pair2 in pairs[index + 1 ..< pairs.count] {
                let match = Match()
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

class Match {
    var pair1 = Pair()
    var pair2 = Pair()
    var mWeight: Int = 0
}

class Pair {
    var player1 = Player()
    var player2 = Player()
    var pWeight: Int = 0
}
    
//    
//    func haveJoinGame(inout playerList:[String:Int] , playerName:String) {
//        playerList[playerName] = playerList[playerName]! + 1
//    }
//    
//    
//    func getRandompair(itemArray:[String], itemArrayTwo:[String]=[]) -> [String]{
//        //C N取M
//        let N = itemArray.count
//        //let M = getM
//        var resultArray:[String] = []
//        var randomIndex = 0 //Int(arc4random_uniform(UInt32(N)))
//        var randomIndexTwo = 0 //Int(arc4random_uniform(UInt32(N)))
//        
//        if itemArrayTwo.count != 0 {
//            randomIndex = Int(arc4random_uniform(UInt32(2)))
//            resultArray.append(itemArray[randomIndex])
//            randomIndexTwo = Int(arc4random_uniform(UInt32(2)))
//            resultArray.append(itemArrayTwo[randomIndex])
//            
//            resultArray.append(itemArray[1-randomIndex])
//            resultArray.append(itemArrayTwo[1-randomIndex])
//        }else {
//            while resultArray.count < N  {
//                randomIndex = Int(arc4random_uniform(UInt32(N)))
//                if !resultArray.contains(itemArray[randomIndex]) {
//                    resultArray.append(itemArray[randomIndex])
//                }
//            }
//        }
//        
//        //print(resultArray)
//        return resultArray
//    }
//    
//    
//    func getGameplayer() -> [String] {
//        let playerMan:[String:Int] = self.playerM
//        let playerFemale:[String:Int] = self.playerF
//        let playerArrayM = Array(playerMan).sort{$0.1 < $1.1}
//        let playerArrayF = Array(playerFemale).sort{$0.1 < $1.1}
//        
//        var gamePlayer:[String] = []
//        
//        var doubleM = 0
//        var doubleF = 0
//        var mix = 0
//        
//        var i = 1
//        
//        //doubleM
//        if playerArrayM.count >= 4 {
//            for (_, value) in playerArrayM {
//                if i <= 4 {
//                    doubleM += value
//                    i += 1
//                }else {
//                    break
//                }
//            }
//            i = 1
//        }else {
//            doubleM = 100000000000000
//        }
//        
//        //doubleF
//        if playerArrayF.count >= 4 {
//            for (_, value) in playerArrayF {
//                if i <= 4 {
//                    doubleF += value
//                    i += 1
//                }else {
//                    break
//                }
//            }
//            i = 1
//        }else {
//            doubleF = 100000000000000
//        }
//        
//        //mix
//        if playerArrayM.count >= 2 && playerArrayF.count >= 2 {
//            for (_, value) in playerArrayM {
//                if i <= 2 {
//                    mix += value
//                    i += 1
//                }else {
//                    break
//                }
//            }
//            i = 1
//            
//            for (_, value) in playerArrayF {
//                if i <= 2 {
//                    mix += value
//                    i += 1
//                }else {
//                    break
//                }
//            }
//            i = 1
//        }else {
//            mix = 100000000000000
//        }
//        
//        if mix <= doubleF && mix <= doubleM {
//            //mix
//            var player1:[String] = []
//            var player2:[String] = []
//            
//            if playerArrayM.count >= 2 && playerArrayF.count >= 2 {
//                for (key, _) in playerArrayM {
//                    if i <= 2 {
//                        player1.append(key)
//                        haveJoinGame(&playerM, playerName: key)
//                        i += 1
//                    }else {
//                        break
//                    }
//                }
//                i = 1
//                
//                for (key, _) in playerArrayF {
//                    if i <= 2 {
//                        player2.append(key)
//                        haveJoinGame(&playerF, playerName: key)
//                        i += 1
//                    }else {
//                        break
//                    }
//                }
//                i = 1
//                gamePlayer = getRandompair(player1, itemArrayTwo: player2)
//            }
//        }else if doubleM <= mix && doubleM <= doubleF {
//            //doubleM
//            if playerArrayM.count >= 4 {
//                for (key, _) in playerArrayM {
//                    if i <= 4 {
//                        gamePlayer.append(key)
//                        haveJoinGame(&playerM, playerName: key)
//                        i += 1
//                    }else {
//                        break
//                    }
//                }
//                i = 1
//                gamePlayer = getRandompair(gamePlayer)
//            }
//            
//        }else {
//            //doubleF
//            if playerArrayF.count >= 4 {
//                for (key, _) in playerArrayF {
//                    if i <= 4 {
//                        gamePlayer.append(key)
//                        haveJoinGame(&playerF, playerName: key)
//                        i += 1
//                    }else {
//                        break
//                    }
//                }
//                i = 1
//                gamePlayer = getRandompair(gamePlayer)
//            }
//        }
//        
//        return gamePlayer
//    }
//    
//    static let shareInstance = Game()
//
//
//class Score {
//    static let shareInstance = Score()
//    
//    var redTeamPlayerOne = ""
//    var redTeamPlayerTwo = ""
//    var blueTeamPlayerOne = ""
//    var blueTeamPlayerTwo = ""
//    var redTeamScore = 0
//    var blueTeamScore = 0
//    
//}
//
//class Scores {
//    var score:[Score] = []
//}
//
//class Ranking {
//    var loseCount = 0
//    var winCount = 0
//    var winRate = CGFloat(0)
//    var pointsAccumulation = 0
//    var playerImage = UIImage()
//    var playerName = ""
//    var RankNumber = "0"
//}