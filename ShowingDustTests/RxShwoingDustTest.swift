//
//  RxShwoingDustTest.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/08/17.
//

import Foundation
import XCTest
import RxTest
@testable import ShowingDust

class RxShowingDustTests: XCTestCase {
    
    func test_url이_올바르지않는경우_TaskError_dataTaskError를_반환해야한다() throws {
        let tmViewModel = ServerViewModel<TMRoot>()
        tmViewModel.url = URL(string:"http:/")
        timeout(2) { exp in
            tmViewModel.rxGetInformation()
                .subscribe{ result in
                    exp.fulfill()
                    switch result {
                    case .error(let error ):
                        let error = error as! TaskError
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
            tmViewModel.rxGetInformation()
                .subscribe{ result in
                    exp.fulfill()
                    switch result {
                    case .error(let error) :
                        let error = error as! TaskError
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
            tmViewModel.rxGetInformation()
                .subscribe{ result in
                    exp.fulfill()
                    switch result {
                    case .error(let error):
                        let error = error as! TaskError
                        XCTAssertTrue(error == TaskError.apiError("Application Error"))
                    case .completed:
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
            tmViewModel.rxGetInformation()
                .subscribe{ result in
                    switch result {
                    case .next(let tmroot):
                        exp.fulfill()
                        XCTAssertNotNil(tmroot.tms?[0])
                    case .completed:
                        XCTAssertTrue(true)
                    default :
                        XCTFail()
                    }
                }
                .dispose()
        }
    }
    
    
    func test_stationAPI호출시_url이_올바르다면_Body가있어야한다() {
        let mockTM = TM(tmX: "200089.126044", tmY: "453946.42329")
        let stationViewModel = ServerViewModel<StationRoot>()
        stationViewModel.setURL(by: .recentStationByTM(mockTM))
        
        timeout(1) { exp in
            stationViewModel.rxGetInformation()
                .subscribe { result in
                    switch result {
                    case .next(let stationRoot):
                        exp.fulfill()
                        XCTAssertNotNil(stationRoot.stationlist?[0])
                    case .completed:
                        XCTAssertTrue(true)
                    default:
                        XCTFail()
                    }
                }
        }
    }
    
    func test_dustAPI호출시_url이_올바르다면_Body가_있어야한다() {
        let dustViewModel = ServerViewModel<DustRoot>()
        dustViewModel.setURL(by: .dustInforByStation(staion: "종로구", dateTerm: .day))
        
        timeout(2) { exp in
            dustViewModel.rxGetInformation()
                .subscribe { result in
                    
                    switch result {
                    case .next(let dustRoot):
                        exp.fulfill()
                        print(dustRoot)
                        XCTAssertNotNil(dustRoot.dust?.items[0])
                    case .completed:
                        XCTAssertTrue(true)
                    case .error(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
        }
    }
    //
    //
    func test_모두_올바른경우에_3가지API모두호출하는_DustViewModel서버통신은_성공한다_() throws {
        let dustViewModel = DustViewModel()
        timeout(2) { exp in
            dustViewModel.rxGetDust(by: "군포시")
                .subscribe { result in
                    switch result {
                    case .next(_) :
                        exp.fulfill()
                        XCTAssert(true)
                    case .completed:
                        XCTAssertTrue(true)
                    default:
                        XCTFail()
                    }
                }
        }
    }
}
