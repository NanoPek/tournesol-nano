//
//  RecommendationWidgetSmallView.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 24/08/2024.
//

import SwiftUI
import DesignSystem

struct RecommendationWidgetSmallView: View {
    let video: WidgetVideo

    var body: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: OpenVideoDetailsIntent(video_id: video.video_id)) {
                labelView
            }
            .buttonStyle(.plain)
        } else {
            labelView
        }
    }

    private var labelView: some View {
        VStack(alignment: .leading) {
            if let rating = video.rating {
                TournesolRating(tournesol_score: rating)
            }
            Text(video.author + " " + (video.uploadDate?.formatted(date: .numeric, time: .omitted) ?? ""))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(video.name)
                .bold()
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
