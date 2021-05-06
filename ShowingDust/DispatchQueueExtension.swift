//
//  DispatchQueueExtension.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/06.
//

import Foundation

extension DispatchQueue {
    static func excuteOnMainQueue(work: @escaping ( () -> Void )) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
