//
//  GameScoreViewController.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 5/6/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit

class GameScoreViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var redSidePicker: UIPickerView!
    @IBOutlet weak var blueSidePicker: UIPickerView!
    
    @IBOutlet weak var redTeamPlayerOne: UILabel!
    @IBOutlet weak var redTeamPlayerTwo: UILabel!
    @IBOutlet weak var blueTeamPlayerOne: UILabel!
    @IBOutlet weak var blueTeamPlayerTwo: UILabel!
    
    @IBOutlet weak var nextBluePlayerOne: UILabel!
    @IBOutlet weak var nextRedPlayerOne: UILabel!
    @IBOutlet weak var nextBluePlayerTwo: UILabel!
    @IBOutlet weak var nextRedPlayerTwo: UILabel!
    
    
    @IBOutlet weak var redTeamPlayerOneImage: UIImageView!
    @IBOutlet weak var redTeamPlayerTwoimage: UIImageView!
    @IBOutlet weak var blueTeamPlayerOneImage: UIImageView!
    @IBOutlet weak var blueTeamPlayerTwoImage: UIImageView!
    
    @IBOutlet weak var nextBlueTeamPlayerOneImage: UIImageView!
    @IBOutlet weak var nextRedTeamPlayerOneImage: UIImageView!
    @IBOutlet weak var nextRedTeamPlayerTwoImage: UIImageView!
    @IBOutlet weak var nextBlueTeamPlayerTwoImage: UIImageView!
    
    var pickerContent:[Int] = []
    var autoSet:[String:Int] = [:]
    var currentSetIndex = 0
    var selectedPlayers = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for player in Game.shareInstance.GamePlayers {
            self.autoSet[player.playerName!] = 0
        }
        Game.shareInstance.playerM = self.autoSet
        
        self.initPicker()
        
//        let rightItem = UIBarButtonItem()
//        let backItem = UIBarButtonItem()
//        rightItem.title = "今日紀錄"
//        rightItem.target = self
//        rightItem.action = #selector(self.getTodayRecord)
//        backItem.title = "我的球隊"
//        backItem.target = self
//        backItem.action = #selector(self.backToGameSet)
//        self.navigationItem.setLeftBarButtonItem(backItem, animated: true)
//        self.navigationItem.setRightBarButtonItem(rightItem, animated: true)
    
    }
    
    @IBAction func finishGameAction(sender: UIButton) {
        
        let list = Game.shareInstance.getGameplayer()
        print(list)
        self.redTeamPlayerOne.text = list[0]
        self.redTeamPlayerTwo.text = list[1]
        self.blueTeamPlayerOne.text = list[2]
        self.blueTeamPlayerTwo.text = list[3]
        
    }
    
    func initPicker() {
        //self.blueSidePicker
        self.blueSidePicker.dataSource = self
        self.blueSidePicker.delegate = self
        
        //self.redSidePicker
        self.redSidePicker.dataSource = self
        self.redSidePicker.delegate = self
        
        for i in 0...35 {
            self.pickerContent.append(i)
        }

        self.redSidePicker.selectRow(0, inComponent: 0, animated: true)
        self.blueSidePicker.selectRow(0, inComponent: 0, animated: true)
    }
    
//    func getTodayRecord() {
//        let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodayRankTableViewController")
//        self.navigationController?.pushViewController(destinationController, animated: true)
//    }
//    
//    func backToGameSet() {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
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
        return self.blueSidePicker.bounds.height
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
