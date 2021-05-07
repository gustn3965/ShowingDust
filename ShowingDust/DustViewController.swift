//
//  DustViewController.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import UIKit
import CoreLocation

class DustViewController: UIViewController {

    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var dustLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hitLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let dustViewModel = DustViewModel()
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        testHitCacheOrDisk()
    }

    @IBAction func touchUpGettingDust() {
        fetchDust()
    }
    
    /// 미세먼지 정보 가져오기.
    /// 1. 사용자의 위치를 가져오고, 지역이름을 가져온다.
    /// 2. 지역이름을 토대로 API호출하여 미세먼지 정보 가져온다.
    func fetchDust() {
        DispatchQueue.global().async {
            self.startProgressBar()
            self.getUserLocation { name in
                guard let name = name else { return }
                self.dustViewModel.getDust(by: name) { data in
                    do {
                        let dust = try data.get()
                        self.updateDisplay(dust: dust, name: name)
                        self.stopProgressBar()
                    } catch {
                        print(error)
                        self.stopProgressBar()
                    }
                }
            }
        }
    }
    
    /// 캐시 또는 디스크에서 가져왔는지 확인하는 test 메서드
    /// NotifcationCenter 에 등록하여 `Cache` 객체에서 응답을 받아오도록 한다.
    func testHitCacheOrDisk() {
        NotificationCenter.default.addObserver(self, selector: #selector(testReceiveHit), name: Notification.Name(rawValue: "CacheHit"), object: nil)
    }

    /// 캐시 또는 디스크에서 가져왔는지 확인하는 test 메서드
    /// - 가져올 경우 하단 `hitLabel`에 표시됨.
    @objc func testReceiveHit(_ notification: Notification) {
        let key = Notification.Name(rawValue: "CacheHit")
        guard let data = notification.userInfo?[key] as? String else { return }
        DispatchQueue.excuteOnMainQueue {
            self.hitLabel.text = data 
        }
    }
    
    // MARK: - UI Update
    func updateDisplay(dust: Dust, name: String ) {
        DispatchQueue.excuteOnMainQueue {
            self.dustLabel.text = dust.dustText
            self.totalLabel.text = dust.totalText
            self.localLabel.text = name
            self.timeLabel.text = dust.dateTime
        }
        changeBackgroundColor(by: dust)
    }
    
    
    func startProgressBar() {
        DispatchQueue.excuteOnMainQueue {
            self.progressBar.startAnimating()
        }
    }
    func stopProgressBar() {
        DispatchQueue.excuteOnMainQueue {
            self.progressBar.stopAnimating()
        }
    }
    
    /// 미세먼지에 따른 `배경화면 색` 변경
    /// - Parameter dust: 미세먼지 정보가 포함된 Dust 타입
    func changeBackgroundColor(by dust: Dust) {
        let value = Int(dust.dust)!
        DispatchQueue.excuteOnMainQueue {
            switch value {
            case 0..<31 :
                self.view.backgroundColor = #colorLiteral(red: 0.75, green: 0.86, blue: 0.98, alpha: 1.00)
            case 31..<71:
                self.view.backgroundColor = .orange
            case 71..<101:
                self.view.backgroundColor = #colorLiteral(red: 0.83, green: 0.25, blue: 0.00, alpha: 1.00)
            default:
                self.view.backgroundColor = #colorLiteral(red: 0.22, green: 0.24, blue: 0.27, alpha: 1.00)
            }
        }
    }
}


