//
//  DateExtension.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

///  현재 시간에서 `시간:00` 만 얻도록 하는 메서드

extension Date {
    static func getCurrentHour() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd kk"
        formatter.locale = Locale(identifier: "ko_KR")
        let hourDate = formatter.string(from: Date())
        formatter.dateFormat = "yyyy-MM-dd kk"
        return formatter.date(from: hourDate)!
    }
}
