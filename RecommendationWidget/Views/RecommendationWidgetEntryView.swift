//
//  EntryView.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 23/08/2024.
//

import SwiftUI

struct RecommendationWidgetEntryView: View {
    let entry: WidgetVideoEntry

    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        if let video = entry.video {
            switch widgetFamily {
            case .systemSmall:
                RecommendationWidgetSmallView(video: video)
            case .systemMedium:
                RecommendationWidgetMediumView(
                    video: video,
                    thumbnail: entry.thumbnail
                )
            default:
                errorView
            }
        } else {
            errorView
        }
    }

    private var errorView: some View {
        Text("An error has occurred, open the app.")
    }
}
