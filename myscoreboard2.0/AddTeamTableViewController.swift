//
//  AddTeamTableViewController.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 6/9/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import UIKit
import SDWebImage

class AddTeamTableViewController: MyScoreBoardEditInfoTableViewController {

    var team = Team()
    var isEditMode = false
    var isTimeSet = false
    
    let dayArray = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
    let startTimeArray = ["00:00","00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00:","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00:","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"]
    let endTimeArray = ["00:00","00:30","01:00:","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00:","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00:","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"]
    
    var daytime:String?
    var starttime:String?
    var endtime:String?
    var isFirstTimeSelectTime = true

    
    @IBOutlet var teamNameTextField: UITextField!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var editPlayersLabel: UILabel!
    @IBOutlet var createTeamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditMode {
            teamNameTextField.text = team.teamName!
            timeLabel.text = team.gameDay! + " " + team.gameTimeHour!
            placeLabel.text = team.place?.name
            editPlayersLabel.text = "成員(\(team.players.count))"
            createTeamButton.setTitle("更新", forState: .Normal)
            photoImageView.sd_setImageWithURL(NSURL(string: team.TeamImageUrl!), placeholderImage: nil)
            createTeamButton.addTarget(self, action: #selector(AddTeamTableViewController.updateTeamInfo), forControlEvents: .TouchUpInside)
        }else{
            createTeamButton.addTarget(self, action: #selector(AddTeamTableViewController.createTeam), forControlEvents: .TouchUpInside)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if team.place != nil {
            placeLabel.text = team.place!.name
        }
        if team.players.isEmpty {
            let currentPlayer = Player()
            currentPlayer.playerId = CurrentUser.sharedInstance.userId
            currentPlayer.playerName = CurrentUser.sharedInstance.username
            currentPlayer.playerImageUrl = CurrentUser.sharedInstance.photo_url
            currentPlayer.gender = CurrentUser.sharedInstance.gender
            team.players.append(currentPlayer)
        }
        
        editPlayersLabel.text = "成員(\(team.players.count))"
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            break
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // select time
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
           let picker: UIPickerView = UIPickerView()
            
           let alertController = UIAlertController(title: "選擇球聚時間", message: "\n\n\n\n\n\n\n\n", preferredStyle: .Alert)
           let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            
               self.daytime = self.dayArray[picker.selectedRowInComponent(0)]
               self.starttime = self.startTimeArray[picker.selectedRowInComponent(1)]
               self.endtime = self.endTimeArray[picker.selectedRowInComponent(2)]
            
               self.team.gameDay = self.daytime
               self.team.gameTimeHour = self.starttime!  + " ~ " + self.endtime!
               self.timeLabel.text = self.team.gameDay! + " " + self.team.gameTimeHour!
               self.isTimeSet = true
           })
            
          let cancelAction = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
           
            print(alertController.view.frame.size)
            
            
            picker.frame = CGRectMake(20, 20, 220, 180)
            picker.delegate = self
            picker.dataSource = self
            
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.selectRow(27, inComponent: 1, animated: false)
            picker.selectRow(27, inComponent: 2, animated: false)
            
            
            self.view.addSubview(picker)
            
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)
           alertController.view.addSubview(picker)
           presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func createTeam() {
        
        var params = ["auth_token": CurrentUser.sharedInstance.authToken!,
                      "name" : teamNameTextField.text!]
        
        // set up params
        params = setParams(params)
        
        if photoImageView.image != nil {
            let path = "https://product.myscoreboardapp.com/api/v1/teams"
            HttpManager.sharedInstance.uploadDataWithImage(HttpMethod.HttpMethodPost,
                                                           path: path,
                                                           uploadImage: photoImageView.image!,
                                                           imageParam: "logo",
                                                           param: params,
                                                           success: { (code, data) in
                                                            print("create team with image success")
                                                            self.team.teamId = data["team_id"].stringValue
                                                            
                                                            if self.team.players.count > 1 {
                                                                self.addPlyaers()
                                                            }else{
                                                                GlobalFunction.sharedInstance.reloadDataFromServer({
                                                                    self.navigationController?.popViewControllerAnimated(true)
                                                                })
                                                            }

                                                            
                }, failure: { (code, data) in
                    print("create team with image failed: \(data)")
                }, complete: nil)
        }else{
            HttpManager.sharedInstance.request(HttpMethod.HttpMethodPost,
                                               apiFunc: APiFunction.CreateTeam,
                                               param: params,
                success: { (code, data) in
                    print("create team success")
                    self.team.teamId = data["team_id"].stringValue
                    
                    if self.team.players.count > 1 {
                        self.addPlyaers()
                    }else{
                        GlobalFunction.sharedInstance.reloadDataFromServer({
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    
                }, failure: { (code, data) in
                    print("create team failed: \(data)")
            })
        }
        
    }
    
    func addPlyaers() {
        
        var playerIds = [String]()
        for player in team.players{
            playerIds.append(player.playerId!)
        }
        
        HttpManager.sharedInstance.request(HttpMethod.HttpMethodPatch,
                                           apiFunc: APiFunction.AddPlayersInTeam,
                                           param: ["auth_token": CurrentUser.sharedInstance.authToken!,
                                            ":id" : team.teamId!,
                                            "added_user_ids" : playerIds],
                                           success: { (code, data) in
                    print("add players success")
                                            GlobalFunction.sharedInstance.reloadDataFromServer({
                                                self.navigationController?.popViewControllerAnimated(true)
                                            })

            }, failure: { (code, data) in
                //failure
                print("error: \(data)")
                
            }, complete: nil)
    }
    
    func updateTeamInfo() {
        
        var params = ["auth_token": CurrentUser.sharedInstance.authToken!,
                      ":id" : team.teamId!,
                      "name" : teamNameTextField.text!]
        
        // set up params
        params = setParams(params)
        let path = "https://product.myscoreboardapp.com/api/v1/teams/\(team.teamId!)"
        
        if photoImageView.image != nil {
            HttpManager.sharedInstance.uploadDataWithImage(HttpMethod.HttpMethodPatch,
                                                           path: path,
                                                           uploadImage: photoImageView.image!,
                                                           imageParam: "logo",
                                                           param: params,
                                                           success: { (code, data) in
                                                            print("create team with image success")
                                                            self.team.teamId = data["team_id"].stringValue
                                                            
                                                            if self.team.players.count > 1 {
                                                                self.addPlyaers()
                                                            }else{
                                                                GlobalFunction.sharedInstance.reloadDataFromServer({
                                                                    self.navigationController?.popViewControllerAnimated(true)
                                                                })
                                                            }
                                                            
                                                            
                }, failure: { (code, data) in
                    print("create team with image failed: \(data)")
                }, complete: nil)
        }else{
            HttpManager.sharedInstance.request(HttpMethod.HttpMethodPatch,
                                               apiFunc: APiFunction.EditTeam,
                                               param: params,
                                               success: { (code, data) in
                                                print("update success")
                                                GlobalFunction.sharedInstance.reloadDataFromServer({
                                                    self.navigationController?.popViewControllerAnimated(true)
                                                })
                                                
                }, failure: { (code, data) in
                    print("update team info failed: \(data)")
            })
        }
        
        
    }

    func setParams(params: Dictionary<String, String>) -> [String: String] {
        
        var newParams = [String: String]()
        newParams.addDictionary(params)
        
        if teamNameTextField.text == nil {
            print("show alert")
        }else if team.place != nil {
            let lat = String((team.place?.latitude)!)
            let lng = String((team.place?.longitude)!)
            let placeDict = ["place_name" : (team.place?.name)!,
                             "address" : (team.place?.address)!,
                             "lat" : lat,
                             "lng" : lng,
                             "google_place_id" : (team.place?.placeId)!]
            newParams.addDictionary(placeDict)
        }else if isTimeSet {
            let timeDict = ["day" : daytime!,
                            "start_time" : starttime!,
                            "end_time" : endtime!]
            newParams.addDictionary(timeDict)
        }

        return newParams
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        if segue.identifier == "GotoSearchLocationPage" {
            let vc = segue.destinationViewController as! SearchLocationTableViewController
            vc.team = team
        }else if segue.identifier == "GoToPlayerListPage" {
            let vc = segue.destinationViewController as! EditPlayerListTableViewController
            vc.team = team
        }
    }

}

extension AddTeamTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3   //有多少個 component
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //設定每個 component 有幾列
        if component == 0{
            return dayArray.count //第一個Component要顯示的數量
        }else if component == 1{
            return startTimeArray.count //第二個Component要顯示的數量
            
        }else{
            return endTimeArray.count  //第三個Component要顯示的數量
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return dayArray[row]  //第一個Component要顯示的文字
            
        }else if component == 1{
            return startTimeArray[row] //第二個Component要顯示的數量
            
        }else{
            return endTimeArray[row]   //第三個Component要顯示的文字
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var titleData = ""
        switch component {
        case 0:
            titleData = String(dayArray[row])
        case 1:
            titleData = String(startTimeArray[row])
        case 2:
            titleData = String(endTimeArray[row])
        default:
            break
        }
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 13 )!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        pickerLabel.backgroundColor = UIColor.clearColor()
        return pickerLabel
    }

}
