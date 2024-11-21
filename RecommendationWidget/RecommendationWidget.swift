//
//  RecommendationWidget.swift
//  RecommendationWidget
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import WidgetKit
import SwiftUI
import Model
import DesignSystem

struct RecommendationWidget: Widget {
    let kind: String = "RecommendationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecoWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                RecommendationWidgetEntryView(entry: entry)
                    .containerBackgroundColor(.appBackground)
            } else {
                RecommendationWidgetEntryView(entry: entry)
                    .padding()
                    .backgroundColor(.appBackground)
            }
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Recommand a video")
        .description("We will recommand you an interesting video every day, directly from your Home Screen!")
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    RecommendationWidget()
} timeline: {
    Constants.placeholderEntry
    WidgetVideoEntry(date: .now, video: nil, thumbnail: nil)
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    RecommendationWidget()
} timeline: {
    Constants.placeholderEntry
    WidgetVideoEntry(date: .now, video: nil, thumbnail: nil)
}
