//
//  Params.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 4/18/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation

struct Params {
    static let PersonalMainPageTitle = "Score Team"
    static let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let passwordReg = "[A-Z0-9a-z._%+-]{8,}"
    
    //api
    static let apiRootPath = "https://product.myscoreboardapp.com/api/v1/"
    static let apiLogin = "login"
    static let apiLogout = "logout"
    static let apiSignup = "signup"
    static let apiCreateTeam = "teams"
    static let apiUpdateTeam = "teams/"
    static let apiAddPlayerInTeam = "teams/"
    static let apiRemovePlayerInTeam = "teams/"
    static let apiEditTeam = "teams/:id/edit"
    static let apiGetTeamList = "teams"
    static let apiSaveGameScore = "games"
    static let apiGetRanking = "games"
    static let apiGetUserStats = "games/stats"
    
}

class Token {
    static let sharedInstance = Token()
    var auth_token: String = ""
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
