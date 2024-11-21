//
//  RecommendationWidgetMediumView.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 24/08/2024.
//

import SwiftUI
import DesignSystem

struct RecommendationWidgetMediumView: View {
    let video: WidgetVideo
    let thumbnail: UIImage?

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
        HStack {
            VStack(alignment: .leading) {
                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFit()
                } else {
                    Rectangle()
                        .fill(.surfaceCard)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fit)
                }
                Text(video.author + " " + (video.uploadDate?.formatted(date: .numeric, time: .omitted) ?? ""))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            VStack(alignment: .leading) {
                if let rating = video.rating {
                    TournesolRating(tournesol_score: rating)
                }
                Text(video.name)
                    .bold()
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}
