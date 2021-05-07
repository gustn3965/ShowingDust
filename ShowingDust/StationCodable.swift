//
//  StationCodable.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation
/*
 *Root
    - *Response
        - *Header
            - code
            - message
        - *Body
            - [*item]
 */

/// Station 정보 관련된 JSon 
struct StationRoot: Codable, ResultCode {
    var response: StationResponse

    var stationlist: [Station]? {
        return response.body?.items
    }
    var resultCode: OpenAPIError {
        return response.header
    }
}

struct StationResponse: Codable {
    var header: StationHeader
    var body: StationBody?
}

struct StationHeader: Codable, OpenAPIError {
    var code: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "resultCode"
        case message =  "resultMsg"
    }
}

struct StationBody: Codable {
    var items: [Station]
}

struct Station: Codable {
    var stationName: String
    var distance: Float
    
    enum CodingKeys: String, CodingKey {
        case distance = "tm"
        case stationName
    }
}
