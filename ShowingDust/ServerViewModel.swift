//
//  StationViewModel.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

/// `URLType에 맞는 정보`를 서버에서 가져온다.
final class ServerViewModel<DataType:Codable> where DataType: ResultCode {
    
    let session: Session = URLSession.shared
    
    private func createReuqest(by urlType: URLType ) -> URLRequest? {
        guard let url = urlType.getURL() else { return nil }
        return URLRequest(url: url)
    }

    /// URLType에 맞는 정보 가져온다.
    /// - Parameters:
    ///   - urlType: `특정 목적`에 따른 정보를 나타냄
    ///   - completion: 가져온 정보를 `success, failure` 반환
    func getInformation(by urlType: URLType, completion: @escaping ( (Result<DataType, TaskError>) -> Void )) {
        guard let request = createReuqest(by: urlType) else { return }
        session.getData(request) { result in
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
