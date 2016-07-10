//
//  Params.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 4/18/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation
import UIKit

struct Params {
    static let PersonalMainPageTitle = "Score Team"
    static let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let passwordReg = "[A-Z0-9a-z._%+-]{8,}"
    
    //collectionView Setting
    static let ANIMATION_SPEED = 0.2
    static let TRANSFORM_CELL_VALUE = CGAffineTransformMakeScale(0.9, 0.9)
    static let spacing:CGFloat = 2.0
    
    
    //api
    static let apiRootPath = "https://product.myscoreboardapp.com/api/v1/"
    static let apiLogin = "login"
    static let apiLogout = "logout"
    static let apiSignup = "signup"
    static let apiUsers = "users/"
    static let apiCreateTeam = "teams"
    static let apiUpdateTeam = "teams/"
    static let apiAddPlayerInTeam = "teams/"
    static let apiRemovePlayerInTeam = "teams/"
    static let apiEditTeam = "teams/:id"
    static let apiGetTeamList = "teams"
    static let apiSaveGameScore = "games"
    static let apiGetRanking = "games"
    static let apiGetUserStats = "games/stats"
    static let apiGetTodayGames = "games/today_games"
    static let apiResetPassword = "reset_password"
    static let apiSearchUser = "users/search"
    static let apiGooglePlaceAutoComplete = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    static let apiGooglePlaceDetail = "https://maps.googleapis.com/maps/api/place/details/json"
    
    //Google place api key
    static let googlePlaceApiKey = "AIzaSyD9Phzy4CZWofeZD3RnEuFemlWTaM4n_po"
}

class GlobalFunction {
    static let sharedInstance = GlobalFunction()
    
    func reloadDataFromServer( completion: () -> ()) -> () {
        HttpManager.sharedInstance
            .request(HttpMethod.HttpMethodGet,
                     apiFunc: APiFunction.GetTeamList,
                     param: ["auth_token" : CurrentUser.sharedInstance.authToken!,
                        ":user_id": CurrentUser.sharedInstance.userId!],
                     success: { (code , data ) in
                        Teams.sharedInstance.teams.removeAll()
                        for team in data["results"].arrayValue {
                            Teams.sharedInstance.teams.append(Team(data: team))
                        }
                     completion()
                        
                },
                     failure: { (code , data) in
                     print("reloadDataFailed: \(data)")
                },
                     complete: nil)
        
    }

    
}

class CurrentUser {
    static let sharedInstance = CurrentUser()
    var authToken: String?
    var userId: String?
    var gender: String?
    var email: String?
    var username: String?
    var photo_url: String?
}

class GameType {
    static let single = "single"
    static let double = "double"
    static let mix = "mix"
}

class GameSetType {
    static let Manual = "手動排賽"
    static let Automatic = "自動排賽"
}

enum ButtonType {
    case FBLogin
    case ApiLogin
    case StartGame
}

enum TextFieldType {
    case Password
    case Account
    case Email
    case UserId
    case NickName
    case Gender
    case ChoseTeam
    case SelectGamePlayer
    case GuestPlayer
    case GameMode
    case TeamName
    //    case GameTime
}

enum PickerType {
    case Gender
    case ChoseTeam
    case GameMode
}

class Gender {
    static let male = "male"
    static let female = "female"
}

struct Result {
    static let win = "W"
    static let loss = "L"
}
