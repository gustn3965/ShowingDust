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
 
 2. 캐시 또는 디스크에 데이터가있다면,
 - 2.1 - 현재지역과 현재시간과 같다면 `캐시 또는 디스크에서 가져온다`.
 - 2.2 - ""     "" 다르다면, DustViewModel 호출하여 가져오고, `저장`한다.

 */


/// 캐시 및 디스크에 저장할 객체
final class CacheValue: Codable {
    var dust: Dust
    var date: Date
    init(dust: Dust, date: Date) {
        self.dust = dust
        self.date = date
    }
}


/// `캐시` 및 `디스크`에 저장 및 가져오는 객체
final class Cache {
    
    private var storage = NSCache<NSString, CacheValue>()
    
    /// `Dust` 및 `Date`를 지역이름의 Key로 `캐시`및 `디스크`에 저장한다.
    /// - Parameters:
    ///   - dust: 저장할 Dust 객체
    ///   - date: 저장할 날짜 Date
    ///   - key: Key가 되는 지역이름
    func save(object dust: Dust, date: Date, key: String) {
        DispatchQueue.global(qos: .background).async {
            let value = CacheValue(dust: dust, date: date)
            self.saveOnCache(value: value, key: key)
            self.saveOnDisk(value: value, key: key)
        }
    }
    
    private func saveOnCache(value: CacheValue, key: String) {
        self.storage.setObject(value, forKey: NSString(string: key))
    }
    private func saveOnDisk(value: CacheValue, key: String) {
        let data = try! JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    
    /// 지역이름(Key)를 기준으로 캐시 및 디스크에서 가져온다.
    ///  만약 데이터가 있을 경우, Date와 비교하여 최신이라면 가져오고,
    ///  그렇지 않다면  nil을 반환하여 API를 호출하도록 한다.
    /// - Parameters:
    ///   - key: Key가 될 지역이름
    /// - Returns: 데이터가 없는 경우 nil반환
    func fetchBy(key: String) -> Dust? {
        let date = Date.getCurrentHour()
        if let value = checkCacheIfLatest(key: NSString(string: key), date: date) {
            return value.dust
        } else if let value = checkDiskIfLatest(key: key, date: date) {
            return value.dust
        } else {
            return nil }
    }
    
    private func checkCacheIfLatest(key: NSString, date: Date ) -> CacheValue?  {
        guard let value = storage.object(forKey: key) else { return nil }
        if value.date == date {
            // TODO: Test 지우기
            testHit(title: "Cache")
            return value }
        return nil
    }
    
    
    private func checkDiskIfLatest(key: String, date: Date ) -> CacheValue?  {
        guard let data = UserDefaults.standard.data(forKey: key) ,
              let value = try? JSONDecoder().decode(CacheValue.self, from: data) else { return nil }
        if value.date == date {
            // TODO:  Test 지우기
            testHit(title: "Disk")
            return value }
        return nil
    }
    
    
    /// 캐시 또는 디스크에 있는 경우 NotifiaitonCenter 를 통해 ViewController에게 전달한다
    /// - Parameter title: Cache  또는 Disk
    private func testHit(title: String) {
        let name = NSNotification.Name("CacheHit")
        NotificationCenter.default.post(name: name, object: nil, userInfo: [name: "\(title) Hit!👍"])
    }
}
