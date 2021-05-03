//
//  Request.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation
import CoreLocation.CLLocation

protocol StationRequest {
    var coordinate: CLLocationCoordinate2D? { get set }
}

// TODO: - Requst는 Request객체만만들도록하자 
extension URLRequest: StationRequest {
}


class A {
    func getRequst() {
        let url = URL(string: "dfas")!
       let request =  URLRequest(url: url)
        request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
    }
}
