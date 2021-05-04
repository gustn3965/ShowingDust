//
//  URLType.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//
import CoreLocation.CLLocation

/// 특정 목적에 맞는 URL 타입 생성
enum URLType {
    case recentStationList(CLLocationCoordinate2D)
    case dustInforByStation(staion: String, dateTerm: DateTerm)
    
    enum DateTerm: String {
        case day = "daily"
        case month = "month"
        case threeMonth = "3month"
    }

    
    /// URLType에 맞는 `url` 반환
    /// - Returns: URLType에 맞는 url 반환
    func getURL() -> URL  {
        var defaultURL = "http://apis.data.go.kr/B552584/"
        let lastURL = "returnType=json&serviceKey=\(KEYEncoding)"
        
        switch self {
        case .recentStationList(let coordinate):
            defaultURL += "MsrstnInfoInqireSvc/getNearbyMsrstnList?"
            defaultURL += "tmX=\(coordinate.latitude)&tmY=\(coordinate.longitude)&"

        case .dustInforByStation(let stationName, let dateTerm): print()
            defaultURL += "ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?"
            defaultURL += "stationName=\(stationName)&dateTerm=\(dateTerm.rawValue)"
        }
        defaultURL += lastURL
        let url = URL(string: defaultURL)!
        print(defaultURL)
        return url
    }
}
