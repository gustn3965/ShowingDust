//
//  StationViewModel.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

/// `URLType에 맞는 정보`를 서버에서 가져온다.
final class ServerViewModel<DataType:Codable> where DataType: ResultCode {

    var session: Session = URLSession.shared
    
    var url: URL?

    // MARK: - Method

    /// `URLType`을 지정하여 url을 초기화한다.
    /// - Parameter urlType: 특정 목적에 맞는 API호출하기 위한 type지정
    func setURL(by urlType: URLType) {
        url = urlType.getURL()
    }
    
    /// URLType에 따른 URLRequest 생성
    /// - Returns: URLRequest
    private func createReuqest() -> URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
    
    /// URLType에 맞는 정보 가져온다.
    /// - Parameters:
    ///   - completion: 가져온 정보를 `success, failure` 반환
    func getInformation(completion: @escaping ( (Result<DataType, TaskError>) -> Void )) {
        guard let request = createReuqest() else {
            completion(.failure(.urlError))
            return }

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
