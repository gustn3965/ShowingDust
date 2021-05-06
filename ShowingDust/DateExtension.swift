//
//  DateExtension.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

extension Date {
    static func getCurrentHour() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH"
        formatter.locale = Locale(identifier: "ko_KR")
        let hourDate = formatter.string(from: Date())+":00"
        formatter.dateFormat = "yyyy-MM-dd HH:00"
        return formatter.date(from: hourDate)!
    }
}
