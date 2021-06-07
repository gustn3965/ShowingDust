//
//  TMCodable.swift
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

/// TM 정보 관련된 JSon
struct TMRoot: Codable, ResultCode {
    var response: TMResponse

    var resultCode: OpenAPIError {
        return response.header
    }
    var tms: [TM]? {
        return response.body?.items
    }
}

struct TMResponse: Codable {
    var header: TMHeader
    var body: TMBody?
}

struct TMHeader: Codable, OpenAPIError {
    var code: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "resultCode"
        case message =  "resultMsg"
    }
}

struct TMBody: Codable {
    var items: [TM]
}

struct TM: Codable {
    var tmX: String
    var tmY: String
}
