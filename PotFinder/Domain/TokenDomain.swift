//
//  TokenDomain.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import ObjectMapper

public struct TokenDomain: Mappable {

    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    var scope: String?
    var jti: String?

    public init?(map: Map) {
        //
    }

    public mutating func mapping(map: Map) {
        accessToken <- map[""]
        tokenType <- map[""]
        expiresIn <- map[""]
        scope <- map[""]
        jti <- map[""]
    }

}
