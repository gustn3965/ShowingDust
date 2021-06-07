//
//  CommonCodable.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

protocol ResultCode {
    var resultCode: OpenAPIError { get }
}
protocol OpenAPIError {
    var code: String { get set }
    var message: String { get set }
}
