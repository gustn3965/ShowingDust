//
//  StationCodable.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation


protocol ResultCode {
    var resultCode: OpenAPIError { get }
}
protocol OpenAPIError {
    var code: String { get set }
    var message: String { get set }
}
/*
 StationRoot
    - StationResponse
        - ErrorCode
        - StationItems
            - Station
 
 */
struct StationRoot: Codable, ResultCode {
    var response: StationResponse

    var stationlist: [Station] {
        return response.body.items
    }
    var resultCode: OpenAPIError {
        return response.header
    }
}
struct StationResponse: Codable {
    var header: StationHeader
    var body: StationBody
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
