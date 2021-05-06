//
//  DustViewController+LocationRequest.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//


import CoreLocation
extension DustViewController: CLLocationManagerDelegate {

    func getUserLocation(completion: @escaping (String) -> Void  ) {
        if checkAuthorization() {
            guard let loc = locationManager.location else { return }
            
            convertLocationToGeocode(loc: loc) { str in
                completion(str)
            }
        }
    }
    
    func convertLocationToGeocode(loc: CLLocation?, completion: @escaping (String) -> Void ) {
        guard let loc = loc else { return }
        CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: Locale(identifier: "Ko-kr")) { resultList, error in
            guard error == nil else { return }
            guard let list = resultList, let location = list.first else { return }
            print(location)
            completion(location.locality!)
        }
    }
    

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
//        switch locationManager.authorizationStatus {
//        case .authorizedAlways:
//            getUserLocation()
//        case .authorizedWhenInUse:
//            locationManager.requestAlwaysAuthorization()
//            getUserLocation()
//        default:
//            return
//        }
    }

    
}
