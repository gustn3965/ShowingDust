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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func test_URL이_올바르지않는경우_urlError를_반환해야한다() throws {
        let tmViewModel = ServerViewModel<TMRoot>()
//        tmViewModel.url =
    }
    
    func test_tmAPI호출시_정상이면서_서버에서_에러가_발생할경우_apiError를_반환해야한다() throws {
        let mockTMRoot = getMockTMRootErrorData()
        let mockTMData = try! jsonEncoder(value: mockTMRoot)
        let session = MockSession()
        session.data = mockTMData
        
        let tmViewModel = ServerViewModel<TMRoot>()
        tmViewModel.session = session
        tmViewModel.setURL(by: .gettingTMByCity("군포시"))
        timeout(1) { exp in
            tmViewModel.getInformation() { result in
                exp.fulfill()
                switch result {
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(error == TaskError.apiError("Application Error"))
                    XCTAssertTrue(true)
                default:
                    XCTFail()
                }
            }
        }
    }
    
    func test_tmAPI호출시_정상이면서_서버에서_에러가_없을경우_tm좌표가_있어야한다() throws {
        let mockTMRoot = getMockTMRootData()
        let mockTmData = try! jsonEncoder(value: mockTMRoot)
        let session = MockSession()
        session.data = mockTmData
        
        let tmViewModel = ServerViewModel<TMRoot>()
        tmViewModel.session = session
        tmViewModel.setURL(by: .gettingTMByCity("군포시"))
        timeout(1) { exp in
            tmViewModel.getInformation { result in
                exp.fulfill()
                switch result {
                case .success(let tmroot):
                   XCTAssertNotNil(tmroot.tms?[0])
                case .failure(let error):
                    XCTFail()
                }
            }
        }
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
    
    func test_지역이름이_있는경우_서버통신은_성공한다_() throws {
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

func getMockTMRootErrorData() -> TMRoot  {
    let tmHeader = TMHeader(code: "01", message: "Application Error")
    let tmResponse = TMResponse(header: tmHeader, body: nil)
    let tmRoot = TMRoot(response: tmResponse)
    return tmRoot
}

func getMockTMRootData() -> TMRoot {
    let tm = TM(tmX: "234234.0000", tmY: "234234.0000")
    let tmBody = TMBody(items: [tm])
    let tmHeader = TMHeader(code: "00", message: "")
    let tmResponse = TMResponse(header: tmHeader, body: tmBody)
    let tmRoot = TMRoot(response: tmResponse)
    return tmRoot
}

class MockSession: Session {
    
    var data: Data?
    
    func getData(_ request: URLRequest, completion: @escaping (Result<Data, TaskError>) -> Void) {
        guard let data = data else {
            completion(.failure(TaskError.dataTaskError))
            return
        }
        completion(.success(data))
    }
}
