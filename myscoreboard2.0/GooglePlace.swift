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
