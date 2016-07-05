//
//  Api.swift
//  MyScoreBoardapp
//
//  Created by MBPrDyson on 5/4/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum HttpMethod {
    case HttpMethodGet
    case HttpMethodPost
    case HttpMethodPatch
}

enum APiFunction {
    case Login
    case Logout
    case FBLogin
    case Register
    case EditUser
    case CreateTeam
    case UpdateTeam
    case AddPlayersInTeam
    case RemovePlayerInTeam
    case EditTeam
    //case LeaveTeam
    case GetTeamList
    case SaveGameScore
    case GetRanking
    case GetUserStats
    case GetTodayGames
    case ResetPassword
    case SearchUser
    case GooglePlaceAutoComplete
    case GooglePlaceDetail
}

typealias HttpCallbackSuccess = (code: Int, data: JSON) -> Void
typealias HttpCallbackFailure = (code: Int?, data: JSON?) -> Void
typealias HttpCallbackComplete = () -> Void

class HttpManager {
    
    static let sharedInstance = HttpManager()
    
    let baseUrl: String = ""
    
    func request(httpMethod: HttpMethod, apiFunc: APiFunction, param: [String: AnyObject]?, success: HttpCallbackSuccess? = nil, failure: HttpCallbackFailure? = nil, complete: HttpCallbackComplete? = nil) {
        
        var requestParam = param
        var path = ""
        var method: Alamofire.Method = .GET
        let encode: ParameterEncoding = .URLEncodedInURL
        
        switch httpMethod {
        case .HttpMethodGet:
            method = .GET
        case .HttpMethodPost:
            method = .POST
        case .HttpMethodPatch:
            method = .PATCH
        }
        
        switch apiFunc {
        case .Login :
            path = Params.apiRootPath + Params.apiLogin
        case .Logout :
            path = Params.apiRootPath + Params.apiLogout
        case .FBLogin :
            path = Params.apiRootPath + Params.apiSignup
        case .Register :
            path = Params.apiRootPath + Params.apiSignup
        case .EditUser :
            path = Params.apiRootPath + Params.apiUsers + CurrentUser.sharedInstance.userId!
            print(path)
        case .CreateTeam :
            path = Params.apiRootPath + Params.apiCreateTeam
        case .UpdateTeam :
            let team_id = String(requestParam![":id"]!)
            path = Params.apiRootPath + Params.apiUpdateTeam + team_id
            //path = Params.apiRootPath + Params.apiUpdateTeam + (requestParam![":id"]?.stringValue)!
            requestParam?.removeValueForKey(":id")
        case .AddPlayersInTeam :
            let team_id = String(requestParam![":id"]!)
            path = Params.apiRootPath + Params.apiAddPlayerInTeam + team_id
            //path = Params.apiRootPath + Params.apiAddPlayerInTeam + (requestParam![":id"]?.stringValue)!
            requestParam?.removeValueForKey(":id")
        case .RemovePlayerInTeam :
            let team_id = String(requestParam![":id"]!)
            path = Params.apiRootPath + Params.apiRemovePlayerInTeam + team_id
            //path = Params.apiRootPath + Params.apiRemovePlayerInTeam + (requestParam![":id"]?.stringValue)!
            requestParam?.removeValueForKey(":id")
        case .EditTeam :
            let team_id = String(requestParam![":id"]!)
            let teamIdAndApiPath = (Params.apiEditTeam as NSString).stringByReplacingOccurrencesOfString(":id", withString: team_id)
            path = Params.apiRootPath + teamIdAndApiPath
            requestParam?.removeValueForKey(":id")
        //case .LeaveTeam :
            //path = Params.apiRootPath + Params.
        case .GetTeamList :
            path = Params.apiRootPath + Params.apiGetTeamList
        case .SaveGameScore :
            path = Params.apiRootPath + Params.apiSaveGameScore
        case .GetRanking :
            path = Params.apiRootPath + Params.apiGetRanking
        case .GetUserStats :
            path = Params.apiRootPath + Params.apiGetUserStats
        case .GetTodayGames :
            path = Params.apiRootPath + Params.apiGetTodayGames
        case .ResetPassword :
            path = Params.apiRootPath + Params.apiResetPassword
        case .SearchUser :
            path = Params.apiRootPath + Params.apiSearchUser
        case .GooglePlaceAutoComplete :
            path = Params.apiGooglePlaceAutoComplete
        case .GooglePlaceDetail :
            path = Params.apiGooglePlaceDetail
        }
        
        switch httpMethod {
        case .HttpMethodGet, .HttpMethodPost:
            Alamofire
                .request(method, path, parameters: requestParam, encoding: encode, headers: nil)
                .responseJSON { (response) in
                    switch response.result {
                    case .Success(let data):
                        let code = response.response?.statusCode
                        
                        if code != nil && code! >= 200 && code! < 300 {
                            success?(code: code!, data: JSON(data))
                        } else {
                            failure?(code: code, data: JSON(data))
                        }
                    case .Failure(_):
                        print("no data responsed")
                        failure?(code: nil, data: nil)
                    }
                    
                    complete?()
            }
        case .HttpMethodPatch :
            Alamofire
                .request(method, path, parameters: requestParam, encoding: encode, headers: nil)
                .responseJSON { (response) in
                    switch response.result {
                    case .Success(let data):
                        let code = response.response?.statusCode
                        
                        if code != nil && code! >= 200 && code! < 300 {
                            success?(code: code!, data: JSON(data))
                        } else {
                            failure?(code: code, data: JSON(data))
                        }
                    case .Failure(_):
                        print("no data responsed")
                        failure?(code: nil, data: nil)
                    }
                    
                    complete?()
            }
        }
        
        
    }
    
    func uploadDataWithImage(httpMethod: HttpMethod,path: String, uploadImage: UIImage, param: [String: AnyObject]?, success: HttpCallbackSuccess? = nil, failure: HttpCallbackFailure? = nil, complete: HttpCallbackComplete? = nil) {
        
        var method: Alamofire.Method = .GET
        
        switch httpMethod {
        case .HttpMethodGet:
            method = .GET
        case .HttpMethodPost:
            method = .POST
        case .HttpMethodPatch:
            method = .PATCH
        }
        
        Alamofire
            .upload(
                method,
                path,
                multipartFormData: { multipartFormData in
                    //multipartFormData.appendBodyPart(data: data, name: name, fileName: "\(name).jpg", mimeType: "image/jpeg")
                    if let imageData = UIImageJPEGRepresentation(uploadImage, 1.0) {
                        multipartFormData.appendBodyPart(data: imageData, name: "logo", fileName: "file.png", mimeType: "image/png")
                    }
                    for (key, value) in param! {
                        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    }
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            switch response.result {
                            case .Success(let data):
                                let code = response.response?.statusCode
                                
                                if code != nil && code! >= 200 && code! < 300 {
                                    success?(code: code!, data: JSON(data))
                                } else {
                                    failure?(code: code, data: JSON(data))
                                }
                            case .Failure(_):
                                print("no data responsed")
                                failure?(code: nil, data: nil)
                            }
                        }
                    case .Failure:
                        failure?(code: nil, data: nil)
                    }
                    complete?()
                }
        )
    }
}

