//
//  UserDefaults+Extension.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/07/13.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let group = "group.hyunsu.park.ShowingDust"
        return UserDefaults(suiteName: group)!
    }
    
    func saveLocation(_ name: String) {
        
        guard var list = value(forKey: "location") as? [String] else {
            setValue([name], forKey: "location")
            return
        }
        if !list.contains(name) {
            list.insert(name, at: 0)
        }
        setValue(list, forKey: "location")
    }
    
    func findLocation() -> String? {
        guard var list = value(forKey: "location") as? [String] else {
            return nil
        }
        return list.first
    }
}
