//
//  DustView.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/07/12.
//

import WidgetKit
import SwiftUI
import Intents

struct ShowingDustWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: changeBackgroundColor(by: entry.dust.dust)),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            DustView(dust: entry.dust, name: entry.name)
        }
    }
}

struct DustView: View {
    let dust: Dust
    let name: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Text("미세먼지")
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(dust.dust)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                }
                HStack {
                    Text("통합대기지수")
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(dust.total)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                Text(dust.dateTime.split(separator: " ").joined(separator: "\n"))
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white)
                Spacer()
                Text(name)
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .padding(.vertical)
            Spacer()
        }
        .padding(.all)
    }
}
