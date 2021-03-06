//
//  DustViewController+LocationRequest.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//


import CoreLocation

/*
 Location 권한, 정보 획득 관련 메서드 
 */
extension DustViewController: CLLocationManagerDelegate {

    func getUserLocation(completion: @escaping (String?) -> Void  ) {
        if checkAuthorization() {
            guard let loc = locationManager.location else { return }
            
            convertLocationToGeocode(loc: loc) { str in
                completion(str)
            }
        } else {
            self.stopProgressBar()
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
            fetchDust()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            fetchDust()
        default:
            stopProgressBar()
            return
        }
    }
}
