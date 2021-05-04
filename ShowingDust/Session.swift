//
//  Session.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation

enum TaskError: Error {
    case userFault
    case serverFault
    case errorFault
    case decodingError
    
    case apiError(String)
}

protocol Session {
    func getData(_ request: URLRequest, completion: @escaping (Result<Data, TaskError>) -> Void )
}

extension URLSession: Session {
    
    /// 요청한 request로 결과( `성공, 실패` ) 받아오기.
    /// - Parameter request: 목적에 따른 request
    func getData(_ request: URLRequest, completion: @escaping (Result<Data, TaskError>) -> Void ) {
        dataTask(with: request) { data, response, error in
            guard error == nil  else { completion(.failure(.errorFault)); return }
            guard let data = data else { completion(.failure(.serverFault)); return }
            completion(.success(data))
        }.resume()
    }
}
