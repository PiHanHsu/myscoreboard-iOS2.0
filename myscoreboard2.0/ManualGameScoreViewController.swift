//
//  ManualGameScoreViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/27/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class ManualGameScoreViewController: MyScoreBoardGameScoreViewController,ChangePlayerDelegate {

    @IBOutlet weak var pair1Player1NameLabel: UILabel!
    @IBOutlet weak var pair1Player2NameLabel: UILabel!
    @IBOutlet weak var pair2Player1NameLabel: UILabel!
    @IBOutlet weak var pair2Player2NameLabel: UILabel!
    
    @IBOutlet weak var pair1Player1ImageView: UIImageView!
    @IBOutlet weak var pair1Player2ImageView: UIImageView!
    @IBOutlet weak var pair2Player1ImageView: UIImageView!
    @IBOutlet weak var pair2Player2ImageView: UIImageView!

    var manualMatch = Match()
    var manualPlayers = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pair1Player1ButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("ManualSelectPlayer", sender: sender)
    }
    
    //change player Delegate
    func changePlayer(player: Player, playerIndex: Int) {
        
        switch playerIndex {
        case 1:
            manualMatch.pair1.player1 = player
        case 2:
            manualMatch.pair1.player2 = player
        case 3:
            manualMatch.pair2.player1 = player
        case 4:
            manualMatch.pair2.player2 = player
        default:
            break
        }
        
        displayCurrentMatchData()
    }
    
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
        
        if let name = manualMatch.pair1.player1?.playerName {
            pair1Player1NameLabel.text = name
        }else {
            pair1Player1NameLabel.text = "選擇球員"
        }
        
        if let name = manualMatch.pair1.player2?.playerName {
            pair1Player2NameLabel.text = name
        }else {
            pair1Player2NameLabel.text = "選擇球員"
        }
        if let name = manualMatch.pair2.player1?.playerName {
            pair2Player1NameLabel.text = name
        }else {
            pair2Player1NameLabel.text = "選擇球員"
        }
        if let name = manualMatch.pair2.player2?.playerName {
            pair2Player2NameLabel.text = name
        }else {
            pair2Player2NameLabel.text = "選擇球員"
        }
        
        
        if let urlString = manualMatch.pair1.player1?.playerImageUrl {
            pair1Player1ImageView.sd_setImageWithURL(NSURL(string: urlString) , placeholderImage: UIImage(named: "user_placeholder"))
        }else {
            pair1Player1ImageView.image = UIImage(named: "user_placeholder")
        }
        
        if let urlString = manualMatch.pair1.player2?.playerImageUrl {
            pair1Player2ImageView.sd_setImageWithURL(NSURL(string: urlString) , placeholderImage: UIImage(named: "user_placeholder"))
        }else {
            pair1Player2ImageView.image = UIImage(named: "user_placeholder")
        }
        
        if let urlString = manualMatch.pair2.player1?.playerImageUrl {
            pair2Player1ImageView.sd_setImageWithURL(NSURL(string: urlString) , placeholderImage: UIImage(named: "user_placeholder"))
        }else {
            pair2Player1ImageView.image = UIImage(named: "user_placeholder")
        }
        
        if let urlString = manualMatch.pair2.player2?.playerImageUrl {
            pair2Player2ImageView.sd_setImageWithURL(NSURL(string: urlString) , placeholderImage: UIImage(named: "user_placeholder"))
        }else {
            pair2Player2ImageView.image = UIImage(named: "user_placeholder")
        }
        
        
    }

    @IBAction func finishGameAction(sender: AnyObject) {
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
        
        let pair1player1Record = ["user":manualMatch.pair1.player1!.playerId!, "score" : score1, "result" : pair1Result]
        let pair1player2Record = ["user":manualMatch.pair1.player2!.playerId!, "score" : score1, "result" : pair1Result]
        let pair2player1Record = ["user":manualMatch.pair2.player1!.playerId!, "score" : score2, "result" : pair2Result]
        let pair2player2Record = ["user":manualMatch.pair2.player2!.playerId!, "score" : score2, "result" : pair2Result]
        
        let scores = [ pair1player1Record, pair1player2Record, pair2player1Record, pair2player2Record ]
        
        if manualMatch.pair1.player1!.gender == manualMatch.pair1.player2!.gender {
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
                        self.checkIfReselectPlayers()
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
    
    func checkIfReselectPlayers() {
        let alertController = UIAlertController(title: "是否重新選擇球員", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "是", style: .Default) { (UIAlertAction) in
            self.manualMatch = Match()
            self.displayCurrentMatchData()
        }
        let cancelAction = UIAlertAction(title: "否", style: .Cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ManualSelectPlayer" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc =  nav.topViewController as! SelectPlayerViewController
            vc.delegate = self
            vc.isChangePlayerMode = true
            vc.changePlayerIndex = sender!.tag
            var players = Teams.sharedInstance.currentPlayingTeam.players
            
            var matchPlayers = [Player?]()
            matchPlayers = [manualMatch.pair1.player1, manualMatch.pair1.player2,manualMatch.pair2.player1,manualMatch.pair2.player2]
            
            switch sender!.tag {
            case 1:
                if manualMatch.pair1.player1 != nil {
                    matchPlayers.removeAtIndex(0)
                }
            case 2:
                if manualMatch.pair1.player2 != nil {
                    matchPlayers.removeAtIndex(1)
                }
            case 3:
                if manualMatch.pair2.player1 != nil {
                    matchPlayers.removeAtIndex(2)
                }
            case 4:
                if manualMatch.pair2.player2 != nil{
                    matchPlayers.removeAtIndex(3)
                }
            default:
                break
            }
            
            for player in matchPlayers {
                if let player = player{
                  players.removeAtIndex(players.indexOf(player)!)
                }
            }
            
            vc.players = players
        }
    }
    

}
