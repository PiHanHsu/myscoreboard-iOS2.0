    //
    //  GameScoreViewController.swift
    //  MyScoreBoardapp
    //
    //  Created by MBPrDyson on 5/6/16.
    //  Copyright © 2016 PiHan Hsu. All rights reserved.
    //
    
    import UIKit
    import SDWebImage
    
    class GameScoreViewController: MyScoreBoardGameScoreViewController, ChangePlayerDelegate {
        
        @IBOutlet weak var pair1Player1NameLabel: UILabel!
        @IBOutlet weak var pair1Player2NameLabel: UILabel!
        @IBOutlet weak var pair2Player1NameLabel: UILabel!
        @IBOutlet weak var pair2Player2NameLabel: UILabel!
        
        @IBOutlet weak var nextPair1Player1NameLabel: UILabel!
        @IBOutlet weak var nextPair1Player2NameLabel: UILabel!
        @IBOutlet weak var nextPair2Player1NameLabel: UILabel!
        @IBOutlet weak var nextPair2Player2NameLabel: UILabel!
        
        @IBOutlet weak var pair1Player1ImageView: UIImageView!
        @IBOutlet weak var pair1Player2ImageView: UIImageView!
        @IBOutlet weak var pair2Player1ImageView: UIImageView!
        @IBOutlet weak var pair2Player2ImageView: UIImageView!
        
        @IBOutlet weak var nextPair1Player1ImageView: UIImageView!
        @IBOutlet weak var nextPair1Player2ImageView: UIImageView!
        @IBOutlet weak var nextPair2Player1ImageView: UIImageView!
        @IBOutlet weak var nextPair2Player2ImageView: UIImageView!
        @IBOutlet weak var finishGameButton: UIButton!
        
        
        var selectedPlayers = [Player]()
        var matchesList: Array<Match>?
        var pairList: Array<Pair>?
        var nextMatch: Match?
        
        var autoSet:[String:Int] = [:]
        var currentSetIndex = 0
        
        var failCount = 0
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            (matchesList, pairList) = MatchList.shareInstance.getMatchesList(selectedPlayers)
            resetWeight(matchesList!)
            //print("matches count: \(matchesList!.count)")
            currentMatch = matchesList![0]
            //print(" currentMatchWeight: \(currentMatch?.mWeight)")
            displayCurrentMatchData()
            createNextMatch(currentMatch!, isSelectedMode: false)
            //createScueduleMatches(matchesList!)
            
            finishGameButton.backgroundColor = UIColor.mainYellowColor()
            finishGameButton.layer.cornerRadius = 5.0
            finishGameButton.clipsToBounds = true
            
            //test
            //self.goTest(100)
            
        }
        func resetWeight(matches: [Match]) {
            
            for match in matches {
                match.pair1.pWeight = 0
                match.pair2.pWeight = 0
                match.pair1.player1?.uWeight = 0
                match.pair1.player2?.uWeight = 0
                match.pair2.player1?.uWeight = 0
                match.pair2.player2?.uWeight = 0
            }
        }
        
        func createNextMatch(match: Match, isSelectedMode: Bool) {
            if !isSelectedMode {
            match.pair1.pWeight += 1
            match.pair2.pWeight += 1
            match.pair1.player1!.uWeight += 10
            match.pair1.player2!.uWeight += 10
            match.pair2.player1!.uWeight += 10
            match.pair2.player2!.uWeight += 10
            }
            matchesList = matchesList?.shuffle()
            matchesList = matchesList?.sort({ $0.mWeight < $1.mWeight})
            nextMatch = matchesList![0]
            
            displayNextMatchData()
 
        }
//        func createScueduleMatches(matches: [Match]) {
//            let match = matches[0]
//            
//                match.pair1.pWeight += 1
//                match.pair2.pWeight += 1
//                match.pair1.player1!.uWeight += 10
//                match.pair1.player2!.uWeight += 10
//                match.pair2.player1!.uWeight += 10
//                match.pair2.player2!.uWeight += 10
//                matchesList = matchesList?.shuffle()
//                matchesList = matches.sort({ $0.mWeight < $1.mWeight})
//                nextMatch = matchesList![0]
//                
//                displayNextMatchData()
//            
//        }
        
        func displayCurrentMatchData() {
            
            //set up layout
            
            pair1Player1ImageView.layoutIfNeeded()
            pair1Player2ImageView.layoutIfNeeded()
            pair2Player1ImageView.layoutIfNeeded()
            pair2Player2ImageView.layoutIfNeeded()
            
            pair1Player1ImageView.layer.cornerRadius = pair1Player1ImageView.frame.size.width / 2
            pair1Player1ImageView.clipsToBounds = true
            pair1Player1ImageView.layer.borderColor = UIColor.redColor().CGColor
            pair1Player1ImageView.layer.borderWidth = 2.0
            pair1Player2ImageView.layer.cornerRadius = pair1Player2ImageView.frame.size.width / 2
            pair1Player2ImageView.clipsToBounds = true
            pair1Player2ImageView.layer.borderColor = UIColor.redColor().CGColor
            pair1Player2ImageView.layer.borderWidth = 2.0
            pair2Player1ImageView.layer.cornerRadius = pair2Player1ImageView.frame.size.width / 2
            pair2Player1ImageView.clipsToBounds = true
            pair2Player1ImageView.layer.borderColor = UIColor.blueColor().CGColor
            pair2Player1ImageView.layer.borderWidth = 2.0
            pair2Player2ImageView.layer.cornerRadius = pair2Player2ImageView.frame.size.width / 2
            pair2Player2ImageView.clipsToBounds = true
            pair2Player2ImageView.layer.borderColor = UIColor.blueColor().CGColor
            pair2Player2ImageView.layer.borderWidth = 2.0
            
            pair1Player1NameLabel.text = currentMatch!.pair1.player1!.playerName
            pair1Player2NameLabel.text = currentMatch!.pair1.player2!.playerName
            pair2Player1NameLabel.text = currentMatch!.pair2.player1!.playerName
            pair2Player2NameLabel.text = currentMatch!.pair2.player2!.playerName
            
            pair1Player1ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair1.player1!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            pair1Player2ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair1.player2!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            pair2Player1ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair2.player1!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            pair2Player2ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair2.player2!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            
        }
        
        func displayNextMatchData() {
            
            //set up layout
            
            nextPair1Player1ImageView.layoutIfNeeded()
            nextPair1Player2ImageView.layoutIfNeeded()
            nextPair2Player1ImageView.layoutIfNeeded()
            nextPair2Player2ImageView.layoutIfNeeded()
            
            nextPair1Player1ImageView.layer.cornerRadius = nextPair1Player1ImageView.frame.size.width / 2
            nextPair1Player1ImageView.clipsToBounds = true
            nextPair1Player2ImageView.layer.cornerRadius = nextPair1Player2ImageView.frame.size.width / 2
            nextPair1Player2ImageView.clipsToBounds = true
            nextPair2Player1ImageView.layer.cornerRadius = nextPair1Player1ImageView.frame.size.width / 2
            nextPair2Player1ImageView.clipsToBounds = true
            nextPair2Player2ImageView.layer.cornerRadius = nextPair1Player1ImageView.frame.size.width / 2
            nextPair2Player2ImageView.clipsToBounds = true
            
            nextPair1Player1NameLabel.text = nextMatch!.pair1.player1!.playerName
            nextPair1Player2NameLabel.text = nextMatch!.pair1.player2!.playerName
            nextPair2Player1NameLabel.text = nextMatch!.pair2.player1!.playerName
            nextPair2Player2NameLabel.text = nextMatch!.pair2.player2!.playerName
            
            nextPair1Player1ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair1.player1!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            nextPair1Player2ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair1.player2!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            nextPair2Player1ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair2.player1!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
            nextPair2Player2ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair2.player2!.playerImageUrl)!) , placeholderImage: UIImage(named: "user_placeholder"))
        }
        
        
        
        @IBAction func finishGameAction(sender: UIButton) {
            
            self.showAndHideIndictor(true)
            
            let score1 = pair1SidePicker.selectedRowInComponent(0)
            let score2 = pair2SidePicker.selectedRowInComponent(0)
            
            var pair1Result = ""
            var pair2Result = ""
            
            if score1 > score2 {
                pair1Result = Result.win
                pair2Result = Result.loss
            }else {
                pair2Result = Result.win
                pair1Result = Result.loss
            }
            let teamId = team.teamId!
            var gameType = ""
            
            let pair1player1Record = ["user":currentMatch!.pair1.player1!.playerId!, "score" : score1, "result" : pair1Result]
            let pair1player2Record = ["user":currentMatch!.pair1.player2!.playerId!, "score" : score1, "result" : pair1Result]
            let pair2player1Record = ["user":currentMatch!.pair2.player1!.playerId!, "score" : score2, "result" : pair2Result]
            let pair2player2Record = ["user":currentMatch!.pair2.player2!.playerId!, "score" : score2, "result" : pair2Result]
            
            let scores = [ pair1player1Record, pair1player2Record, pair2player1Record, pair2player2Record ]
            
            if currentMatch!.pair1.player1!.gender == currentMatch!.pair1.player2!.gender {
                gameType = GameType.double
            }else {
                gameType = GameType.mix
            }
            
                        HttpManager.sharedInstance
                            .request(HttpMethod.HttpMethodPost,
                                     apiFunc: APiFunction.SaveGameScore,
                                     param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
                                        "team_id": teamId,
                                        "game_type": gameType,
                                        "scores" : scores],
                                     success: { (code , data ) in
                                        print("score saved!!")
                                        self.currentMatch = self.nextMatch
                                        self.displayCurrentMatchData()
                                        self.createNextMatch(self.currentMatch!, isSelectedMode: false)
                                        self.pair1SidePicker.selectRow(0, inComponent: 0, animated: true)
                                        self.pair2SidePicker.selectRow(0, inComponent: 0, animated: true)
                                        self.showAndHideIndictor(false)
                                },
                                     failure: { (code , data) in
                                        let alertController = UIAlertController(title: "Something wrong with internet", message: "Score did not save, please try again", preferredStyle: .Alert)
                                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: {
                                            UIAlertAction in
                                            self.showAndHideIndictor(false)
                                        })
                                        alertController.addAction(alertAction)
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                        print("failed with \(code), \(data)")
                                },
                                     complete: nil)
        }
        
        // Change player
        
        
        @IBAction func pair1Player1ButtonPressed(sender: AnyObject) {
            performSegueWithIdentifier("ChangePlayer", sender: sender)
        }
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "ChangePlayer" {
                
                let nav = segue.destinationViewController as! UINavigationController
                let vc =  nav.topViewController as! SelectPlayerViewController
                vc.delegate = self
                vc.isChangePlayerMode = true
                vc.changePlayerIndex = sender!.tag
                
                var currentMatchPlayers = [currentMatch!.pair1.player1, currentMatch!.pair1.player2, currentMatch!.pair2.player1, currentMatch!.pair2.player2]
                switch sender!.tag {
                case 1:
                    currentMatchPlayers.removeAtIndex(0)
                case 2:
                    currentMatchPlayers.removeAtIndex(1)
                case 3:
                    currentMatchPlayers.removeAtIndex(2)
                case 4:
                    currentMatchPlayers.removeAtIndex(3)
                default:
                    break
                }
                
                var players = Teams.sharedInstance.currentPlayingTeam.players
                for player in currentMatchPlayers {
                    players.removeAtIndex(players.indexOf(player!)!)
                }
                vc.players = players
                
            }
        }
        
        //MARK: - test
        
        func goTest(times: Int) {
            for _ in 0...times{
                testAlgorithm()
            }
            
            if failCount == 0 {
                print("success")
            }else{
                print("failed: \(failCount)")
            }
        }
        
        func testAlgorithm(){
            let matchList = MatchList()
            (matchesList, pairList) = matchList.getMatchesList(selectedPlayers)
            resetWeight(matchesList!)
            var match = Match()
            let set = NSCountedSet()
            match = matchesList![0]
            for _ in 0...selectedPlayers.count-1 {
                
                set.addObject(match.pair1.player1!)
                set.addObject(match.pair1.player2!)
                set.addObject(match.pair2.player1!)
                set.addObject(match.pair2.player2!)
                
                //match.pair1.pWeight += 1
                //match.pair2.pWeight += 1
                match.pair1.player1!.uWeight += 10
                match.pair1.player2!.uWeight += 10
                match.pair2.player1!.uWeight += 10
                match.pair2.player2!.uWeight += 10
                
                //print("match weight: \(match.mWeight)")
                //print("player weight: \(match.pair1.player1!.uWeight)")
                matchesList = matchesList?.shuffle()
                matchesList = matchesList!.sort({ $0.mWeight < $1.mWeight})
                nextMatch = matchesList![0]
                let matchPlayerArray = [match.pair1.player1!,  match.pair1.player2!,match.pair2.player1!, match.pair2.player2! ]
                
                if matchPlayerArray.contains((nextMatch?.pair1.player1)!){
                    nextMatch?.pair1.player1!.uWeight += 0
                }else if matchPlayerArray.contains((nextMatch?.pair1.player2)!){
                    nextMatch?.pair1.player2!.uWeight += 0
                }else if matchPlayerArray.contains((nextMatch?.pair2.player1)!){
                    nextMatch?.pair2.player1!.uWeight += 0
                }else if matchPlayerArray.contains((nextMatch?.pair2.player2)!){
                    nextMatch?.pair2.player2!.uWeight += 0
                }
                //                for (index, match) in matchesList!.enumerate() {
                //                    print("match\(index) : \(match.mWeight)")
                //                }
                
                match = nextMatch!
                
                //print("\(match.pair1.player1!.playerName!) \(match.pair1.player2!.playerName!) \(match.pair2.player1!.playerName!) \(match.pair2.player2!.playerName!) \(match.mWeight)")
                
            }
            
            for player in selectedPlayers {
                
                if set.countForObject(player) != 4 {
                    print("\(player.playerName): \(set.countForObject(player))")
                    failCount += 1
                    return
                }
            }
        }
        
        //change player Delegate
        func changePlayer(player: Player, playerIndex: Int) {
            
            player.uWeight -= 10
            switch playerIndex {
            case 1:
                currentMatch!.pair1.player1 = player
                currentMatch!.pair1.player1?.uWeight += 10
            case 2:
                currentMatch!.pair1.player2 = player
                currentMatch!.pair1.player2?.uWeight += 10
            case 3:
                currentMatch!.pair2.player1 = player
                currentMatch!.pair2.player1?.uWeight += 10
            case 4:
                currentMatch!.pair2.player2 = player
                currentMatch!.pair2.player2?.uWeight += 10
            default:
                break
            }
            
            displayCurrentMatchData()
            createNextMatch(currentMatch!, isSelectedMode: true)
            
        }
    }
