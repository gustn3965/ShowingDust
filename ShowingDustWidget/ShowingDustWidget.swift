//
//  ShowingDustWidget.swift
//  ShowingDustWidget
//
//  Created by hyunsu on 2021/07/12.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DustEntry {
        DustEntry.mock("장비이상", ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DustEntry) -> ()) {
        let currentDate = Date()
        let dustViewModel = DustViewModel()
        let location = UserDefaults.shared.findLocation() ?? "군포시"
        
        dustViewModel.getDust(by: location) { data in
            switch data {
            case .success(let dust):
                let location = UserDefaults.shared.findLocation() ?? "TEST"
                let entry = DustEntry(date: currentDate,
                                      dust: dust[0],
                                      name: location,
                                      configuration: configuration)
                completion(entry)
            case .failure(let error):
                completion(DustEntry.mock("장비이상", configuration))
                print(error)
            }
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<DustEntry>) -> ()) {
        
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
        let dustViewModel = DustViewModel()
        let location = UserDefaults.shared.findLocation() ?? "군포시"
        dustViewModel.getDust(by: location) { data in
            switch data {
            case .success(let dust):
                
                let entry = DustEntry(date: currentDate,
                                      dust: dust[0],
                                      name: location,
                                      configuration: configuration)
                let timeline = Timeline(entries: [entry], policy: .after(nextDate))
                completion(timeline)
            case .failure(let error):
                let failedEntry = DustEntry.mock("장비이상", configuration)
                let timeline = Timeline(entries: [failedEntry], policy: .after(nextDate))
                completion(timeline)
                print(error)
            }
        }
    }
}

@main
struct ShowingDustWidget: Widget {
    let kind: String = "ShowingDustWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ShowingDustWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is Dust Widget")
        .supportedFamilies([.systemSmall])
    }
}

struct ShowingDustWidget_Previews: PreviewProvider {
    static var previews: some View {
        ShowingDustWidgetEntryView(entry: DustEntry(date: Date(),
                                                      dust: Dust(dateTime: "2021-07-12 16:00", dust: "30", total: "50"),
                                                      name: "군포시",
                                                      configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        ShowingDustWidgetEntryView(entry: DustEntry(date: Date(),
                                                      dust: Dust(dateTime: "2021-07-12 16:00", dust: "70", total: "70"),
                                                      name: "군포시",
                                                      configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        ShowingDustWidgetEntryView(entry: DustEntry(date: Date(),
                                                      dust: Dust(dateTime: "2021-07-12 16:00", dust: "100", total: "100"),
                                                      name: "군포시",
                                                      configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        ShowingDustWidgetEntryView(entry: DustEntry(date: Date(),
                                                      dust: Dust(dateTime: "2021-07-12 16:00", dust: "140", total: "100"),
                                                      name: "군포시",
                                                      configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


