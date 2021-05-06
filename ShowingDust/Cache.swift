//
//  Cache.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

/**
 캐싱
 1. 캐시에 데이터가없다면,
 - DustViewModel 호출하여 캐시에 `저장`한다.
 
 2. 캐시에 데이터가있다면,
 - 2.1 - 현재지역과 현재시간과 같다면 `캐시에서 가져온다`.
 - 2.2 - ""     "" 다르다면, DustViewModel 호출하여 가져오고, `저장`한다.
 */

final class CacheValue: Codable {
    var dust: Dust
    var date: Date
    init(dust: Dust, date: Date) {
        self.dust = dust
        self.date = date
    }
}

final class Cache {
    
    private var storage = NSCache<NSString, CacheValue>()
    
    func save(object dust: Dust, date: Date, key: String) {
        DispatchQueue.global(qos: .background).async {
            let value = CacheValue(dust: dust, date: date)
            self.saveCache(value: value, key: key)
            self.saveDisk(value: value, key: key)
        }
    }
    
    private func saveCache(value: CacheValue, key: String) {
        self.storage.setObject(value, forKey: NSString(string: key))
    }
    private func saveDisk(value: CacheValue, key: String) {
        let data = try! JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    func fetchBy(key: String, date: Date ) -> Dust? {
        if let value = checkCache(key: NSString(string: key), date: date) {
            return value.dust
        } else if let value = checkDisk(key: key, date: date) {
            return value.dust
        } else {
            return nil }
    }
    
    private func checkCache(key: NSString, date: Date ) -> CacheValue?  {
        guard let value = storage.object(forKey: key) else { return nil }
        if value.date == date {
            // TODO: Test 지우기
            testHit(title: "Cache")
            return value }
        return nil
    }
    
    
    private func checkDisk(key: String, date: Date ) -> CacheValue?  {
        guard let data = UserDefaults.standard.data(forKey: key) ,
              let value = try? JSONDecoder().decode(CacheValue.self, from: data) else { return nil }
        if value.date == date {
            // TODO:  Test 지우기
            testHit(title: "Disk")
            return value }
        return nil
    }
    
    private func testHit(title: String) {
        let name = NSNotification.Name("CacheHit")
        NotificationCenter.default.post(name: name, object: nil, userInfo: [name: "\(title) Hit!👍"])
    }
}
