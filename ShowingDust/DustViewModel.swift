//
//  DustViewModel.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation


/// 서버와 통신하는 `3단계`를 합쳐 `미세먼지 정보`만 가져오도록 하는 객체
final class DustViewModel {
    
    let session: Session = URLSession.shared
    
    let tmViewModel = ServerViewModel<TMRoot>()
    let stationViewModel = ServerViewModel<StationRoot>()
    let dustViewModel = ServerViewModel<DustRoot>()
    
    
    /// 미세먼지 정보만 가져오는 메서드
    /// - Parameters:
    ///   - urlType: 타입을 지정할 수 있지만,  Controller에서 사용하는 경우는 위치이름만 넣도록한다.
    ///   - completion: 가져온 데이터가 성공적인지 실패인지 받는 클로저
    func getDust(by urlType: URLType, completion: @escaping ( (Result<Dust, TaskError>) -> Void )) {
        tmViewModel.getInformation(by: urlType) { resultTM  in
            switch resultTM {
            case .failure(let err): completion(.failure(err))
            case .success(let tmRoot):
                self.stationViewModel.getInformation(by: URLType.recentStationByTM(tmRoot.tms![0])) { resultLocation in
                    switch resultLocation {
                    case .failure(let err): completion(.failure(err))
                    case .success(let locationRoot):
                        self.dustViewModel.getInformation(
                            by: .dustInforByStation(staion: locationRoot.stationlist![0].stationName,
                                                    dateTerm: .day)) { resultDust in
                            switch resultDust {
                            case .failure(let err): completion(.failure(err))
                            case .success(let dustRoot):
                                completion(.success(dustRoot.dust!.items[0]))
                            }
                        }
                    }
                }
            }
//            do {
//                let tmLocation = try resultTM.get().tms![0]
//
//                self.stationViewModel.getInformation(by: URLType.recentStationByTM(tmLocation)) { locaitons in
//                    do {
//                        let location = try locaitons.get().stationlist![0]
//
//                        self.dustViewModel.getInformation(
//                            by: .dustInforByStation(staion: location.stationName,
//                                                    dateTerm: .day)) { dustData in
//                            do {
//                                let dust = try dustData.get().dust
//                                completion(.success(dust!.items[0]))
//                            } catch {
//                                completion(.failure(error as! TaskError))
//                            }
//                        }
//                    } catch {
//                        completion(.failure(error as! TaskError))
//                    }
//                }
//            } catch {
//                completion(.failure(error as! TaskError))
//            }
            
        }
        
    }
}
