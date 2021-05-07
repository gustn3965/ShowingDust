//
//  DustCodable.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/04.
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

/// 미세먼지 정보 관련된 JSon 
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
    var dateTime: String
    var dust: String
    var total: String

    enum CodingKeys: String, CodingKey {
        case dust = "pm10Value"
        case total = "khaiValue"
        case dateTime = "dataTime"
    }
    
    var format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    var dustText: String { return "미세먼지: \(dust)"}
    var totalText: String { return "통합대기지수: \(total)"}
    var date: Date {
        return format.date(from: dateTime)!
    }
}
