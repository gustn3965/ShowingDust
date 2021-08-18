//
//  DustViewController+LocationRequest.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//


import CoreLocation
import RxSwift

/*
 Location 권한, 정보 획득 관련 메서드 
 */

enum LocationError: Error {
    case invalid
}
extension DustViewController: CLLocationManagerDelegate {

    func getUserLocation(completion: @escaping (Result<String, LocationError>) -> Void ) {
        if checkAuthorization() {
            guard let loc = locationManager.location else {
                completion(.failure(.invalid))
                return
            }
            
            convertLocationToGeocode(loc: loc) { str in
                if let str = str {
                    completion(.success(str))
                } else {
                    completion(.failure(.invalid))
                }
            }
        } else {
            self.stopProgressBar()
        }
    }
    
    func rxGetUserLcoation() -> Observable<String> {
        return Observable.create() { [weak self] completion in
            self?.getUserLocation(completion: { result in
                switch result {
                case .success(let name):
                    completion.onNext(name)
                    completion.onCompleted()
                case .failure(let error):
                    completion.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    
    /// CLLocation을 통하여 지역이름 반환한다.
    /// - Parameters:
    ///   - loc: 사용자의 위치를 담은 CLLocation
    ///   - completion: 변환된 지역이름 없을경우 nil
    func convertLocationToGeocode(loc: CLLocation, completion: @escaping (String?) -> Void ) {
        CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: Locale(identifier: "Ko-kr")) { resultList, error in
            guard error == nil else {
                completion(nil)
                return }
            guard let list = resultList, let location = list.first else { return }
            completion(location.locality!)
        }
    }
    
    
    /// 사용자 위치 권한 확인하는 메서드
    /// - Returns: true - 권한획득 완료
    func checkAuthorization() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        return false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            rxFetchDust()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            rxFetchDust()
            print()
        default:
            rxFetchDust()
            return
        }
    }
}
