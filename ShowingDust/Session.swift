//
//  Session.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation

protocol StationSession {
    func getData(_ request: URLRequest)
}

extension URLSession: StationSession {
    func getData(_ request: URLRequest) {
        dataTask(with: request) { data, response, error in
            print(error)
        }.resume()
    }
}

class StationViewModel {
    
}

/*
 request를 바탕으로 session에서 data task 수행.
 */
