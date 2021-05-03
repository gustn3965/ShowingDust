//
//  DustViewController+LocationRequest.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//


import CoreLocation

extension DustViewController: CLLocationManagerDelegate {

    func getUserLocation()  {
        if checkAuthorization() {
            print(locationManager.location)
            locationManager.location?.coordinate.longitude
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
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            getUserLocation()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            getUserLocation()
        default:
            return
        }
    }

    
}
