//
//  ApiService.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/11/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import SwiftHTTP
import CoreLocation
import MapKit

struct Token: Codable {
    let access_token: String?
    let token_type: String?
    let expires_in: Int?
    let scope: String?
    let jti: String?
}

public struct Location: Codable {
    let locationUid: String?
    let locationType: String?
    let parentLocationUid: String?
    let coordinatesType: String?
    let coordinates: String?
}

public struct LocationResponse: Codable {
    let content: [Location]?
    let last: Bool?
    let totalPages: Int?
    let totalElements: Int?
    let numberOfElements: Int?
    let first: Bool?
    let sort: String?
    let size: Int?
    let number: Int?
}

public class ApiService {

    private static var _instance: ApiService? = nil

    static var instance: ApiService {
        if _instance == nil {
            _instance = ApiService()
        }
        return _instance!
    }

    private init(){}

    func logInToApi(onSuccess successHandler: @escaping (Token) -> (),
                    onFailure failureHandler: @escaping (Int?) -> ()) {
        let url = AppConstants.uaaUrl
        let loginString = "\(AppConstants.username):\(AppConstants.password)"
        guard let loginData = loginString.data(using: .utf8) else {
            return
        }
        let encodedData = loginData.base64EncodedString()
        let headers: [String: String] = [
            "Authorization": "Basic \(encodedData)"
        ]

        HTTP.GET(url,
                 parameters: nil,
                 headers: headers) { (response) in
                    if (response.error != nil) {
                        failureHandler(response.statusCode)
                        return
                    }
                    switch response.statusCode ?? -1 {
                    case 200..<400:
                        let decoder = JSONDecoder()
                        do {
                            let token = try decoder.decode(Token.self, from: response.data)
                            successHandler(token)
                        } catch _ {
                            failureHandler(nil)
                        }

                    default:
                        failureHandler(response.statusCode ?? -1)
                        return
                    }
        }

    }

    func getAllLocations(for boundingBox: [CLLocationCoordinate2D],
                         onSucess successHander: @escaping (LocationResponse) -> (),
                         onFailure failureHandler: @escaping (Int?) -> ()) {

//        var bbox = "\(boundingBox[0].latitude):\(boundingBox[0].longitude),\(boundingBox[1].latitude):\(boundingBox[1].longitude)"

        let bbox = "42.847483:-73.999931,42.761227:-73.885101"

        let url = AppConstants.locationUrl
            .replacingOccurrences(of: "{{metadataurl}}", with: AppConstants.metadataUrl)
            .replacingOccurrences(of: "{{bbox}}", with: bbox)

        guard let token = UserDefaults.standard.value(forKey: AppConstants.tokenKey) as? String else {
            failureHandler(-1)
            return
        }

        let headers: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Predix-Zone-Id": "Schenectady-IE-TRAFFIC"
        ]

        HTTP.GET(url,
                 parameters: nil,
                 headers: headers) { (response) in
                    if (response.error != nil) {
                        failureHandler(response.statusCode)
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let locationResponse = try decoder.decode(LocationResponse.self, from: response.data)
                        successHander(locationResponse)
                        return
                    } catch _ {
                        failureHandler(nil)
                        return
                    }
        }

    }
}
