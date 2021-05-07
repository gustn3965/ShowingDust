//
//  MockSession.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/07.
//

@testable import ShowingDust
import Foundation

class MockSession: Session {
    
    var data: Data?
    
    func getData(_ request: URLRequest, completion: @escaping (Result<Data, TaskError>) -> Void) {
        guard let data = data else {
            completion(.failure(TaskError.dataTaskError))
            return
        }
        completion(.success(data))
    }
}
