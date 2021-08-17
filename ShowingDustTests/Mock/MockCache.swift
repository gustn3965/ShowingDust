//
//  MockCache.swift
//  ShowingDustTests
//
//  Created by hyunsu on 2021/05/11.
//

import Foundation
@testable import ShowingDust

class MockCache: Cache {
    func removeData(by key: String) {
    }
    
    
    func fetchBy(key: String) -> Dust? {
        return nil
    }
    
    func save(object dust: Dust, key: String, completion: (() -> Void)?) {
    }
}
