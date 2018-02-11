//
//  AppConstants.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

enum AppConstants {
    static let metadataUrl = "https://ic-metadata-service.run.aws-usw02-pr.ice.predix.io/v2/metadata"
    static let locationUrl = "{{metadataurl}}/locations/search?q=locationType:TRAFFIC_LANE&bbox={{bbox}}&page=0&size=1000"
    static let uaaUrl = "https://890407d7-e617-4d70-985f-01792d693387.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token?grant_type=client_credentials"
    static let username = "sch.hackathon"
    static let password = "hackathon"
    static let tokenKey = "tokenKey"
}
