//
//  ShowingDustTests.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/07.
//

import XCTest

@testable import ShowingDust

class ShowingDustTests: XCTestCase {

    func test_url이_올바르지않는경우_TaskError_dataTaskError를_반환해야한다() throws {
        let tmViewModel = ServerViewModel<TMRoot>()
        tmViewModel.url = URL(string:"http:/")
        timeout(2) { exp in
            tmViewModel.getInformation { result in
                exp.fulfill()
                switch result {
                case .failure(let error):
                    XCTAssert(error == TaskError.dataTaskError, error.localizedDescription)
                default:
                    XCTFail()
                }
            }
        }
    }
    
    func test_tmAPI_url이_올바르지않은_경우_TaskError_urlError를_반환해야한다() throws {
        let tmViewModel = ServerViewModel<TMRoot>()
        var defaultURL = "http://apis.data.go.kr/"
        defaultURL += "MsrstnInfoInqireSvc/getTMStdrCrdnt?"
        let encodedName = "군포시".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        defaultURL += "umdName=\(encodedName)&"
        defaultURL += "returnType=json&serviceKey=\(KEYEncoding)"
        
        tmViewModel.url = URL(string:defaultURL)
        timeout(3) { exp in
            tmViewModel.getInformation { result in
                exp.fulfill()
                switch result {
                case .failure(let error):
                    XCTAssert(error == TaskError.urlError, error.localizedDescription)
                default:
                    XCTFail()
                }
            }
        }
    }
    
    func test_tmAPI호출시_정상이면서_서버에서_에러가_발생할경우_apiError를_반환해야한다() throws {
        let mockTMRoot = getMockTMRootErrorData()
        let mockTMData = try! jsonEncoder(value: mockTMRoot)
        let session = MockSession()
        session.data = mockTMData
        
        let tmViewModel = ServerViewModel<TMRoot>()
        tmViewModel.session = session
        tmViewModel.setURL(by: .gettingTMByCity("군포시"))
        timeout(2) { exp in
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
        timeout(2) { exp in
            tmViewModel.getInformation { result in
                exp.fulfill()
                switch result {
                case .success(let tmroot):
                    XCTAssertNotNil(tmroot.tms?[0])
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    
    func test_stationAPI호출시_url이_올바르다면_Body가있어야한다() {
        let mockTM = TM(tmX: "200089.126044", tmY: "453946.42329")
        let stationViewModel = ServerViewModel<StationRoot>()
        stationViewModel.setURL(by: .recentStationByTM(mockTM))
        
        timeout(1) { exp in
            stationViewModel.getInformation { result in
                exp.fulfill()
                switch result {
                case .success(let stationRoot):
                    XCTAssertNotNil(stationRoot.stationlist?[0])
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    func test_dustAPI호출시_url이_올바르다면_Body가_있어야한다() {
        let dustViewModel = ServerViewModel<DustRoot>()
        dustViewModel.setURL(by: .dustInforByStation(staion: "종로구", dateTerm: .day))
        
        timeout(2) { exp in
            dustViewModel.getInformation { result in
                exp.fulfill()
                switch result {
                case .success(let dustRoot):
                    XCTAssertNotNil(dustRoot.dust?.items[0])
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    
    func test_모두_올바른경우에_3가지API모두호출하는_DustViewModel서버통신은_성공한다_() throws {
        let dustViewModel = DustViewModel()
        timeout(2) { exp in
            dustViewModel.getDust(by: "군포시") { result in
                exp.fulfill()
                switch result {
                case .success(_) :
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

