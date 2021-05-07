//
//  ShowingDustTests.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/07.
//

import XCTest

@testable import ShowingDust

class ShowingDustTests: XCTestCase {
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    func test_지역이름이_없는경우_서버통신은_실패한다() throws {
        let dustViewModel = DustViewModel()
        timeout(2) { exp in
            dustViewModel.getDust(by: "") { result in
                exp.fulfill()
                switch result {
                case .failure(let error) :
                    XCTAssert(true)
                default:
                    XCTFail()
                }
            }
        }
    }
    
    func test_지역이름이_있는경우_서버통신은_성공한다() throws {
        let dustViewModel = DustViewModel()
        timeout(2) { exp in
            dustViewModel.getDust(by: "군포시") { result in
                exp.fulfill()
                switch result {
                case .success(let dust) :
                    XCTAssert(true)
                default:
                    XCTFail()
                }
            }
        }
    }
    
    
    
    func test_tmAPI호출시_서버에러가_날경우_에러를_반환해야한다() throws {
        let tmRoot = getMockTMRootData()
    
        let session = MockSession()
        
    }

}

extension XCTestCase {
    func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")

        completion(exp)

        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }

}

func getMockTMRootData() -> TMRoot  {
    var tmHeader = TMHeader(code: "01", message: "Application Error")
    var tmResponse = TMResponse(header: tmHeader, body: nil)
    var tmRoot = TMRoot(response: tmResponse)
    return tmRoot
}

class MockSession: Session {
    
    var data: Data?
    
    func getData(_ request: URLRequest, completion: @escaping (Result<Data, TaskError>) -> Void) {
        guard let data = data else {
            completion(.failure(TaskError.errorFault))
            return
        }
        completion(.success(data))
    }
}
