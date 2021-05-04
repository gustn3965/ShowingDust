//
//  DustViewController.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import UIKit
import CoreLocation
class DustViewController: UIViewController {

    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    // TODO: - 유저위치 권한받아오기
    @IBAction func touchpUpCurrent() {
        getUserLocation()
        DustViewModel<StationRoot>()
            .getInformation(by: .recentStationList( CLLocationCoordinate2D(latitude: 244148.546388, longitude: 412423.75772))) { result in
            do {
                let stationData = try result.get()
                print("-")
                print(stationData.stationlist)
            } catch {
                print(error)
            }
        }
    }
}


