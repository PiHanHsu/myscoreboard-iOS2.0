//
//  GooglePlace.swift
//  myscoreboard2.0
//
//  Created by PiHan Hsu on 7/5/16.
//  Copyright © 2016 PiHan Hsu. All rights reserved.
//

import Foundation

public enum PlaceType: CustomStringConvertible {
    case All
    case Geocode
    case Address
    case Establishment
    case Regions
    case Cities
    
    public var description : String {
        switch self {
        case .All: return ""
        case .Geocode: return "geocode"
        case .Address: return "address"
        case .Establishment: return "establishment"
        case .Regions: return "(regions)"
        case .Cities: return "(cities)"
        }
    }
}

class Place: NSObject {
    var placeId: String
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String
    
    init(placeId: String, name: String, latitude: Double, longitude: Double, address: String) {
        
        self.placeId = placeId
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

//public class Place: NSObject {
//    public let id: String
//    public let desc: String
//    public var apiKey: String?
//    
//    override public var description: String {
//        get { return desc }
//    }
//    
//    public init(id: String, description: String) {
//        self.id = id
//        self.desc = description
//    }
//    
//    public convenience init(prediction: [String: AnyObject], apiKey: String?) {
//        self.init(
//            id: prediction["place_id"] as! String,
//            description: prediction["description"] as! String
//        )
//        
//        self.apiKey = apiKey
//    }
//}

//public class PlaceDetails: CustomStringConvertible {
//    public let name: String
//    public let latitude: Double
//    public let longitude: Double
//    public let raw: [String: AnyObject]
//    
//    public init(json: [String: AnyObject]) {
//        let result = json["result"] as! [String: AnyObject]
//        let geometry = result["geometry"] as! [String: AnyObject]
//        let location = geometry["location"] as! [String: AnyObject]
//        
//        self.name = result["name"] as! String
//        self.latitude = location["lat"] as! Double
//        self.longitude = location["lng"] as! Double
//        self.raw = json
//    }
//    
//    public var description: String {
//        return "PlaceDetails: \(name) (\(latitude), \(longitude))"
//    }
//}
