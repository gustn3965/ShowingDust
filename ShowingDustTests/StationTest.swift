//
//  StationTest.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/03.
//

import XCTest
@testable import ShowingDust
import CoreLocation.CLLocation

class StationTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_올바르지못한_request는_실패한다() throws {
        XCTFail()
    }
    
    func test_올바른_reuqest는_성공한다() throws {
        let mockCoordinate = CLLocationCoordinate2D(latitude: 37.554466, longitude: 126.858037)
        let viewModel = DustViewModel<StationCode>()
        timeout(1) { exp in
            viewModel.getInformation(by: .recentStationList(mockCoordinate)) { result in
                exp.fulfill()
                do {
                    try result.get()
                    XCTAssertTrue(true)
                } catch {
                    XCTFail("없음")
                }
            }
        }
        
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
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