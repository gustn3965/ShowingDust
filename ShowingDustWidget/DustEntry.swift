//
//  DustEntry.swift
//  ShowingDustWidgetExtension
//
//  Created by hyunsu on 2021/07/12.
//

import WidgetKit
import Intents


struct DustEntry: TimelineEntry {
    let date: Date
    let dust: Dust
    let name: String 
    let configuration: ConfigurationIntent
    
    static func mock(_ text: String,
                     _ configuration : ConfigurationIntent) -> DustEntry {
        return DustEntry(date: Date(),
                         dust: Dust(dateTime: "-",
                                    dust: "-",
                                    total: "-"),
                         name: text,
                         configuration: configuration)
    }
}



