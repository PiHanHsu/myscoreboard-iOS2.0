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
        
        var pickerContent:[Int] = []
        var autoSet:[String:Int] = [:]
        var currentSetIndex = 0
        var selectedPlayers = [Player]()
        var matchesList: Array<Match>?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            matchesList = MatchList.shareInstance.getMatchesList(selectedPlayers)
            displayData()
            print("matches count: \(matchesList!.count)")
                        self.initPicker()
            
            
        }
        
        func displayData() {
            if matchesList!.count > 1 {
                pair1Player1NameLabel.text = matchesList?[0].pair1.player1.playerName
                pair1Player2NameLabel.text = matchesList?[0].pair1.player2.playerName
                pair2Player1NameLabel.text = matchesList?[0].pair2.player1.playerName
                pair2Player2NameLabel.text = matchesList?[0].pair2.player2.playerName
                
                pair1Player1ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[0].pair1.player1.playerImageUrl)!) , placeholderImage: nil)
                pair1Player2ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[0].pair1.player2.playerImageUrl)!) , placeholderImage: nil)
                pair2Player1ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[0].pair2.player1.playerImageUrl)!) , placeholderImage: nil)
                pair2Player2ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[0].pair2.player2.playerImageUrl)!) , placeholderImage: nil)
                nextPair1Player1NameLabel.text = matchesList?[1].pair1.player1.playerName
                nextPair1Player2NameLabel.text = matchesList?[1].pair1.player2.playerName
                nextPair2Player1NameLabel.text = matchesList?[1].pair2.player1.playerName
                nextPair2Player2NameLabel.text = matchesList?[1].pair2.player2.playerName
                
                
                nextPair1Player1ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[1].pair1.player1.playerImageUrl)!) , placeholderImage: nil)
                nextPair1Player2ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[1].pair1.player2.playerImageUrl)!) , placeholderImage: nil)
                nextPair2Player1ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[1].pair2.player1.playerImageUrl)!) , placeholderImage: nil)
                nextPair2Player2ImageView.sd_setImageWithURL(NSURL(string: (matchesList?[1].pair2.player2.playerImageUrl)!) , placeholderImage: nil)
            }

        }
        
        @IBAction func finishGameAction(sender: UIButton) {
            
            matchesList?.removeAtIndex(0)
            displayData()
            //        let list = Game.shareInstance.getGameplayer()
            //        print(list)
            //        self.redTeamPlayerOne.text = list[0]
            //        self.redTeamPlayerTwo.text = list[1]
            //        self.blueTeamPlayerOne.text = list[2]
            //        self.blueTeamPlayerTwo.text = list[3]
            
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
