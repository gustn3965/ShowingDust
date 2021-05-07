//
//  MockTMData.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/07.
//

import XCTest
@testable import ShowingDust

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
