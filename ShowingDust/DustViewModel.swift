//
//  DustViewModel.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation

class DustViewModel<DataType:Codable> where DataType: ResultCode {
    
    let session: Session = URLSession.shared
    
    func createReuqest(by urlType: URLType ) -> URLRequest {
        let request = URLRequest(url: urlType.getURL())
        return request
    }
    
    func getInformation(by urlType: URLType, completion: @escaping ( (Result<DataType, TaskError>) -> Void )) {
        session.getData(createReuqest(by: urlType)) { result in
            switch result {
            case .success(let data):
                
                do {
                    let resultData = try jsonDecoder(type: DataType.self, data: data)
                    switch resultData.resultCode.code {
                    case "00" :
                        completion(.success(resultData))
                    default :
                        completion(.failure(.apiError(resultData.resultCode.message)))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
}
