    //
    //  GameScoreViewController.swift
    //  MyScoreBoardapp
    //
    //  Created by MBPrDyson on 5/6/16.
    //  Copyright © 2016 PiHan Hsu. All rights reserved.
    //
    
    import UIKit
    import SDWebImage
    
    class GameScoreViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
        
        @IBOutlet weak var pair1SidePicker: UIPickerView!
        @IBOutlet weak var pair2SidePicker: UIPickerView!
        
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
        
        var team = Team()
        var selectedPlayers = [Player]()
        var matchesList: Array<Match>?
        var currentMatch: Match?
        var nextMatch: Match?

        var pickerContent:[Int] = []
        var autoSet:[String:Int] = [:]
        var currentSetIndex = 0
        
        var failCount = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            matchesList = MatchList.shareInstance.getMatchesList(selectedPlayers)
            print("matches count: \(matchesList!.count)")
            currentMatch = matchesList![0]
            print(" currentMatchWeight: \(currentMatch?.mWeight)")
            displayCurrentMatchData()
            //createScueduleMatches(matchesList!)
            self.initPicker()
            for _ in 0...100{
                testAlgorthim()
            }
            
            //testAlgorthim()
            if failCount == 0 {
                print("success")
            }else{
                print("failed: \(failCount)")
            }
        }
        
        //test
        func testAlgorthim(){
            var match = Match()
            let set = NSCountedSet()
            match = matchesList![0]
            for _ in 0...selectedPlayers.count-1 {
                
               
                
                set.addObject(match.pair1.player1)
                set.addObject(match.pair1.player2)
                set.addObject(match.pair2.player1)
                set.addObject(match.pair2.player2)
                
                match.pair1.pWeight += 1
                match.pair2.pWeight += 1
                match.pair1.player1.uWeight += 50
                match.pair1.player2.uWeight += 50
                match.pair2.player1.uWeight += 50
                match.pair2.player2.uWeight += 50
                
                matchesList = matchesList?.shuffle()
                matchesList = matchesList!.sort({ $0.mWeight < $1.mWeight})
                nextMatch = matchesList![0]
              let matchPlayerArray = [match.pair1.player1,        match.pair1.player2,match.pair2.player1, match.pair2.player2 ]
                if matchPlayerArray.contains((nextMatch?.pair1.player1)!){
                    nextMatch?.pair1.player1.uWeight += 0
                }else if matchPlayerArray.contains((nextMatch?.pair1.player2)!){
                    nextMatch?.pair1.player2.uWeight += 0
                }else if matchPlayerArray.contains((nextMatch?.pair2.player1)!){
                    nextMatch?.pair2.player1.uWeight += 0
                }else if matchPlayerArray.contains((nextMatch?.pair2.player2)!){
                    nextMatch?.pair2.player2.uWeight += 0
                }
                
                match = nextMatch!
                
                //print("\(match.pair1.player1.playerName!) \(match.pair1.player2.playerName!) \(match.pair2.player1.playerName!) \(match.pair2.player2.playerName!) \(match.mWeight)")
                
                
           }
            
            for player in selectedPlayers {
                
                if set.countForObject(player) != 4 {
                    //print("\(player.playerName): \(set.countForObject(player))")
                    failCount += 1
                    return
                }
            }
        }
        
        func createScueduleMatches(matches: [Match]) {
            let match = matches[0]
            
            match.pair1.pWeight += 1000
            match.pair2.pWeight += 1000
            match.pair1.player1.uWeight += 100
            match.pair1.player2.uWeight += 100
            match.pair2.player1.uWeight += 100
            match.pair2.player2.uWeight += 100
            
            matchesList = matchesList?.shuffle()
            matchesList = matches.sort({ $0.mWeight < $1.mWeight})
            nextMatch = matchesList![0]
            
            displayNextMatchData()
        
        }
        
        func displayCurrentMatchData() {
                
                pair1Player1NameLabel.text = currentMatch!.pair1.player1.playerName
                pair1Player2NameLabel.text = currentMatch!.pair1.player2.playerName
                pair2Player1NameLabel.text = currentMatch!.pair2.player1.playerName
                pair2Player2NameLabel.text = currentMatch!.pair2.player2.playerName
                
                pair1Player1ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair1.player1.playerImageUrl)!) , placeholderImage: nil)
                pair1Player2ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair1.player2.playerImageUrl)!) , placeholderImage: nil)
                pair2Player1ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair2.player1.playerImageUrl)!) , placeholderImage: nil)
                pair2Player2ImageView.sd_setImageWithURL(NSURL(string: (currentMatch!.pair2.player2.playerImageUrl)!) , placeholderImage: nil)
            
        }
        
        func displayNextMatchData() {
            
            nextPair1Player1NameLabel.text = nextMatch!.pair1.player1.playerName
            nextPair1Player2NameLabel.text = nextMatch!.pair1.player2.playerName
            nextPair2Player1NameLabel.text = nextMatch!.pair2.player1.playerName
            nextPair2Player2NameLabel.text = nextMatch!.pair2.player2.playerName
            
            nextPair1Player1ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair1.player1.playerImageUrl)!) , placeholderImage: nil)
            nextPair1Player2ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair1.player2.playerImageUrl)!) , placeholderImage: nil)
            nextPair2Player1ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair2.player1.playerImageUrl)!) , placeholderImage: nil)
            nextPair2Player2ImageView.sd_setImageWithURL(NSURL(string: (nextMatch!.pair2.player2.playerImageUrl)!) , placeholderImage: nil)
        }
        
        
        @IBAction func finishGameAction(sender: UIButton) {
            
            self.currentMatch = self.nextMatch
            self.displayCurrentMatchData()
            self.createScueduleMatches(self.matchesList!)
            
//            let teamId = team.teamId!
//            var gameType = ""
//            
//            let pair1player1Record = ["user":currentMatch!.pair1.player1.playerId!, "score" : "21", "result" : "W"]
//            let pair1player2Record = ["user":currentMatch!.pair1.player2.playerId!, "score" : "21", "result" : "W"]
//            let pair2player1Record = ["user":currentMatch!.pair2.player1.playerId!, "score" : "19", "result" : "L"]
//            let pair2player2Record = ["user":currentMatch!.pair2.player2.playerId!, "score" : "19", "result" : "L"]
//            let scores = [ pair1player1Record, pair1player2Record, pair2player1Record, pair2player2Record ]
//            
//            if currentMatch!.pair1.player1.gender == currentMatch!.pair1.player2.gender {
//                gameType = GameType.double
//            }else {
//                gameType = GameType.mix
//            }
//            
//            HttpManager.sharedInstance
//                .request(HttpMethod.HttpMethodPost,
//                         apiFunc: APiFunction.SaveGameScore,
//                         param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
//                                     "team_id": teamId,
//                                    "gameType": gameType,
//                                     "scores" : scores],
//                         success: { (code , data ) in
//                         print("score saved!!")
//                         self.currentMatch = self.nextMatch
//                         self.displayCurrentMatchData()
//                         self.createScueduleMatches(self.matchesList!)
//                    },
//                         failure: { (code , data) in
//                         print("failed with \(code), \(data)")
//                    },
//                         complete: nil)

            
        }
        
        func initPicker() {
            //self.blueSidePicker
            self.pair2SidePicker.dataSource = self
            self.pair2SidePicker.delegate = self
            
            //self.redSidePicker
            self.pair1SidePicker.dataSource = self
            self.pair1SidePicker.delegate = self
            
            for i in 0...35 {
                self.pickerContent.append(i)
            }
            
            self.pair1SidePicker.selectRow(0, inComponent: 0, animated: true)
            self.pair2SidePicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        // MARK: - UIPickerViewDataSource
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.pickerContent.count
        }
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // MARK: - UIPickerViewDelegate
        
        //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        let titleData = String(self.pickerContent[row])
        //        let myTitle = NSAttributedString(string:titleData, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        //        return String(myTitle)
        //    }
        //
        //    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //        let titleData = String(self.pickerContent[row])
        //        let myTitle = NSAttributedString(string:titleData, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        //        return myTitle
        //    }
        
        func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
            let pickerLabel = UILabel()
            let titleData = String(self.pickerContent[row])
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size:pickerView.bounds.height * 8/10 )!,NSForegroundColorAttributeName:UIColor.whiteColor()])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .Center
            pickerLabel.backgroundColor = UIColor.clearColor()
            return pickerLabel
        }
        
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print("end picker : \(self.pickerContent[row])")
            //self.selectedGender = pickerContent[row]
        }
        
        func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return self.pair2SidePicker.bounds.height
        }
        
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
        }
        
        
    }
