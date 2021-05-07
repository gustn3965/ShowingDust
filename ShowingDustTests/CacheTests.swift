//
//  CacheTests.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/07.
//

import XCTest
@testable import ShowingDust
class CacheTests: XCTestCase {
    func test_캐시가_없다면_nil이여야한다() throws {
        let cache = Cache()
        XCTAssertNil(cache.fetchBy(key: "???"))
    }
    
    func test_캐시가_있으면서_최신이라면_nil이_아니여야한다() throws {
        let cache = Cache()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = Date.getCurrentHour()
        let strDate = format.string(from: currentDate)
        cache.save(object: Dust(dateTime: strDate, dust: "123", total: "123"), key: "TEST")
        XCTAssertNotNil(cache.fetchBy(key: "TEST"))
    }
    
    func test_캐시가_있으면서_최신이_아니라면_nil이여야한다() throws {
        let cache = Cache()
        let strDate = "2020-05-05 01:00"
        cache.save(object: Dust(dateTime: strDate, dust: "123", total: "123"), key: "TEST2")
        XCTAssertNil(cache.fetchBy(key: "TEST2"))
    }
}
