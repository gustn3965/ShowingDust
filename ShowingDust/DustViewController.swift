//
//  DustViewController.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import UIKit
import CoreLocation
class DustViewController: UIViewController {
    @IBOutlet var progressBar: UIActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var dustLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let dustViewModel = DustViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    // TODO: - 유저위치 권한받아오기
    @IBAction func touchUpGettingDust() {
        DispatchQueue.global().async {
            self.startProgressBar()
            self.getUserLocation { name in
                self.dustViewModel.getDust(by: .gettingTMByCity(name)) { data in
                    do {
                        let result = try data.get()
                        DispatchQueue.main.async {
                            self.dustLabel.text = result.dustText
                            self.totalLabel.text = result.totalText
                            self.localLabel.text = name
                            self.timeLabel.text = result.dataTime
                            self.stopProgressBar()
                            self.changeBackgroundColorBy(dust: result)
                        }
                    } catch {
                        print(error)
                        self.stopProgressBar()
                    }
                }
            }
        }
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
    func changeBackgroundColorBy(dust: Dust) {
        let value = Int(dust.dust)!
        DispatchQueue.excuteOnMainQueue {
            switch value {
            case 0..<31 :
                self.view.backgroundColor = .systemBlue
            case 31..<71:
                self.view.backgroundColor = .orange
            default:
                self.view.backgroundColor = .red
            }
        }
        
    }
    
    // WARNING: 하지마
    func get() { }
}


