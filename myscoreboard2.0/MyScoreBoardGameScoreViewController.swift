//
//  MyScoreBoardGameScoreViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/27/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import UXTesting

class MyScoreBoardGameScoreViewController: UIViewController {
    
    @IBOutlet weak var pair1SidePicker: UIPickerView!
    @IBOutlet weak var pair2SidePicker: UIPickerView!
    @IBOutlet weak var pair1PickerBackgroundView: UIView!
    @IBOutlet weak var pair2PickerBackgroundView: UIView!
    
    //@IBOutlet weak var finishGameButton: UIButton!
    
    let team = Teams.sharedInstance.currentPlayingTeam
    var currentMatch: Match?
    
    var pickerContent = [Int]()
    let backGroundView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pair1SidePicker.dataSource = self
        self.pair1SidePicker.delegate = self
        
        pair1PickerBackgroundView.layer.cornerRadius = 8.0
        pair1PickerBackgroundView.clipsToBounds = true
        pair2PickerBackgroundView.layer.cornerRadius = 8.0
        pair2PickerBackgroundView.clipsToBounds = true
        
        //pair2 pickerView
        self.pair2SidePicker.dataSource = self
        self.pair2SidePicker.delegate = self
        
        for i in 0...35 {
            self.pickerContent.append(i)
        }
        
        self.pair1SidePicker.selectRow(0, inComponent: 0, animated: true)
        self.pair2SidePicker.selectRow(0, inComponent: 0, animated: true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backGroundView.backgroundColor = UIColor.lightGrayColor()
        backGroundView.alpha = 0.8
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.center = backGroundView.center
        indicator.startAnimating()
        backGroundView.addSubview(indicator)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UXTestingManager.sharedInstance().heatMapStartWithViewName("Game Score Page")
    }
    
    // finish game indicator
    
    func showAndHideIndictor(isSavingMode: Bool) {
        
        
        if isSavingMode {
            self.view .addSubview(backGroundView)
        }else{
            backGroundView.removeFromSuperview()
        }
    }
    
//    @IBAction func finishGameAction(sender: UIButton) {
//        
//        self.showAndHideIndictor(true)
//        
//        let score1 = pair1SidePicker.selectedRowInComponent(0)
//        let score2 = pair2SidePicker.selectedRowInComponent(0)
//        
//        var pair1Result = ""
//        var pair2Result = ""
//        
//        if score1 > score2 {
//            pair1Result = Result.win
//            pair2Result = Result.loss
//        }else {
//            pair2Result = Result.win
//            pair1Result = Result.loss
//        }
//        let teamId = team.teamId!
//        var gameType = ""
//        var scores = []
//
//        if currentMatch!.pair1.player2 == nil {
//            let pair1player1Record = ["user":currentMatch!.pair1.player1!.playerId!, "score" : score1, "result" : pair1Result]
//            let pair2player1Record = ["user":currentMatch!.pair2.player1!.playerId!, "score" : score2, "result" : pair2Result]
//            scores = [ pair1player1Record, pair2player1Record ]
//            gameType = GameType.single
//        }else{
//            let pair1player1Record = ["user":currentMatch!.pair1.player1!.playerId!, "score" : score1, "result" : pair1Result]
//            let pair1player2Record = ["user":currentMatch!.pair1.player2!.playerId!, "score" : score1, "result" : pair1Result]
//            let pair2player1Record = ["user":currentMatch!.pair2.player1!.playerId!, "score" : score2, "result" : pair2Result]
//            let pair2player2Record = ["user":currentMatch!.pair2.player2!.playerId!, "score" : score2, "result" : pair2Result]
//            
//            scores = [ pair1player1Record, pair1player2Record, pair2player1Record, pair2player2Record ]
//            
//            if currentMatch!.pair1.player1!.gender == currentMatch!.pair1.player2!.gender {
//                gameType = GameType.double
//            }else {
//                gameType = GameType.mix
//            }
// 
//        }
//        
//        HttpManager.sharedInstance
//            .request(HttpMethod.HttpMethodPost,
//                     apiFunc: APiFunction.SaveGameScore,
//                     param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
//                        "team_id": teamId,
//                        "game_type": gameType,
//                        "scores" : scores],
//                     success: { (code , data ) in
//                        print("score saved!!")
////                        self.currentMatch = self.nextMatch
////                        self.displayCurrentMatchData()
////                        self.createScueduleMatches(self.matchesList!)
//                        self.pair1SidePicker.selectRow(0, inComponent: 0, animated: true)
//                        self.pair2SidePicker.selectRow(0, inComponent: 0, animated: true)
//                        self.showAndHideIndictor(false)
//                },
//                     failure: { (code , data) in
//                        let alertController = UIAlertController(title: "Something wrong with internet", message: "Score did not save, please try again", preferredStyle: .Alert)
//                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: {
//                            UIAlertAction in
//                            self.showAndHideIndictor(false)
//                        })
//                        alertController.addAction(alertAction)
//                        self.presentViewController(alertController, animated: true, completion: nil)
//                        print("failed with \(code), \(data)")
//                },
//                     complete: nil)
//    }
//
}

extension MyScoreBoardGameScoreViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerContent.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = String(self.pickerContent[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size:pickerView.bounds.height * 8/10 )!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        pickerLabel.backgroundColor = UIColor.clearColor()
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.pair2SidePicker.bounds.height
    }
 
}
