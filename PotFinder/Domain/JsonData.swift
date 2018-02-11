//
//  JsonData.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/11/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import ObjectMapper

struct EachLocation: Mappable {
    var CreateDateTime: String?
    var DisplayNAme: Int?
    var Distance: String?
    var EndTime: String?
    var EventTypeID: Int?
    var EventTypeNAme: String?
    var Heading: String?
    var Latitude: Double?
    var Location: String?
    var Longitude: Double?
    var StartTime: String?
    var StreetSpeed: Int?
    var VehicleEventID: Int?
    var VehicleID: Int?

    init?(map: Map) {
        //
    }

    mutating func mapping(map: Map) {
        CreateDateTime <- map["CreateDateTime"]
        DisplayNAme <- map["DisplayNAme"]
        Distance <- map["Distance"]
        EndTime <- map["EndTime"]
        EventTypeID <- map["EventTypeID"]
        EventTypeNAme <- map["EventTypeNAme"]
        Heading <- map["Heading"]
        Latitude <- map["Latitude"]
        Location <- map["Location"]
        Longitude <- map["Longitude"]
        StartTime <- map["StartTime"]
        StreetSpeed <- map["StreetSpeed"]
        VehicleEventID <- map["VehicleEventID"]
        VehicleID <- map["VehicleID"]

    }
}

struct JsonData: Mappable {
    var jsonData: [EachLocation]?

    init?(map: Map) {
        //
    }

    mutating func mapping(map: Map) {
        jsonData <- map["jsonData"]
    }
}
