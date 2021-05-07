//
//  APIError.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/07.
//

import Foundation

enum TaskError: Error {
    case urlError
    case dataTaskError
    case decodingError

    /// API호출 성공하면서 API내에서 에러를 반환하는경우
    case apiError(String)
}
