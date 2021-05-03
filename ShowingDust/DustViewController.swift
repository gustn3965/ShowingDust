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
    }
}


