//
//  APIError.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/07.
//

import Foundation

enum TaskError: Error, Equatable, LocalizedError {
    case urlError
    case dataTaskError
    case decodingError

    /// API호출 성공하면서 API내에서 에러를 반환하는경우
    case apiError(String)
    
    var localizedDescription: String {
        switch self {
        case .urlError: return "Invalid URL Error"
        case .dataTaskError: return "Data Task Error"
        case .decodingError: return "Decoding Error"
        case .apiError(let error): return error 
        }
    }
}
