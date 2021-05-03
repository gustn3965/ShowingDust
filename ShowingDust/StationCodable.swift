//
//  StationCodable.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation

struct StationCode: Codable {
    var resultCode: Int
    var resultMsg: String
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
