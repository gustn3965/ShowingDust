//
//  URLType.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//
import CoreLocation.CLLocation


/// 특정 목적에 맞는 URL 타입 생성
enum URLType {

    case gettingTMByCity(String)
    case dustInforByStation(staion: String, dateTerm: DateTerm)
    case recentStationByTM(TM)
    
    enum DateTerm: String {
        case day = "daily"
        case month = "month"
        case threeMonth = "3month"
    }

    
    /// URLType에 맞는 `url` 반환
    /// - Returns: URLType에 맞는 url 반환
    func getURL() -> URL?  {
        var defaultURL = "http://apis.data.go.kr/B552584/"
        let lastURL = "returnType=json&serviceKey=\(KEYEncoding)"
        
        switch self {
        
        case .gettingTMByCity(let name):
            defaultURL += "MsrstnInfoInqireSvc/getTMStdrCrdnt?"
            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            defaultURL += "umdName=\(encodedName)&"
            
        case .recentStationByTM(let tm):
            defaultURL += "MsrstnInfoInqireSvc/getNearbyMsrstnList?"
            defaultURL += "tmX=\(tm.tmX)&tmY=\(tm.tmY)&"
        
        case .dustInforByStation(let stationName, let dateTerm): print()
            defaultURL += "ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?"
            defaultURL += "numOfRows=1&"
            let encodedName = stationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            defaultURL += "stationName=\(encodedName)&dataTerm=\(dateTerm.rawValue)&"

        }
        defaultURL += lastURL
        print(defaultURL)
        
        return URL(string: defaultURL)
    }
}
