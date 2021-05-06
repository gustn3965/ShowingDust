//
//  DustCodable.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/04.
//

import Foundation

struct DustRoot: Codable, ResultCode {
    var response: DustResponse
    var resultCode: OpenAPIError {
        return response.header
    }
    var dust: DustBody? {
        return response.body
    }
}
struct DustResponse: Codable {
    var header: DustHeader
    var body: DustBody?
}
struct DustHeader: Codable, OpenAPIError {
    var code: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "resultCode"
        case message = "resultMsg"
    }
}

struct DustBody: Codable {
    var items: [Dust]
}
struct Dust: Codable {
    var dataTime: String
    var dust: String
    var total: String
    enum CodingKeys: String, CodingKey {
        case dust = "pm10Value"
        case total = "khaiValue"
        case dataTime
    }
}
