//
//  PotHole.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import ObjectMapper

public struct PotHoleDomain: Mappable {

    var zipcode: String?
    var lattitude: Double?
    var longitude: Double?
    var userId: String?
    var address: String?
    var imageData: String?

    public init?(map: Map) {
        //
    }

    public mutating func mapping(map: Map) {
        zipcode <- map["zipcode"]
        lattitude <- map["lattitude"]
        longitude <- map["longitude"]
        userId <- map["userId"]
        address <- map["address"]
        imageData <- map["imageData"]
    }
}
