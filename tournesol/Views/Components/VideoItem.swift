//
//  VideoItem.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import SwiftUI
import Model
import DesignSystem
import YouTubePlayerKit

struct VideoItem: View {
    private let video_id: String
    private let video: VideoResult?
    private let action: ((VideoResult) -> Void)?

    init(video_id: String, video: VideoResult?, action: ((VideoResult) -> Void)?) {
        self.video_id = video_id
        self.video = video
        self.action = action
    }

    init(video: VideoResult, action: ((VideoResult) -> Void)?) {
        self.video_id = video.video_id
        self.video = video
        self.action = action
    }

    @Environment(\.openURL) private var openURL
    @Environment(\.showError) private var showError

    @State private var youTubePlayer: YouTubePlayer?

    var body: some View {
        contentView
            .backgroundColor(.surfaceCard)
            .cornerRadius(.small)
    }

    private var contentView: some View {
        VStack {
            Button {
                Haptics.shared.play(.medium)
                self.youTubePlayer = YouTubePlayer(
                    source: .video(id: video_id),
                    configuration: .init(autoPlay: true)
                )
            } label: {
                ThumbnailView(video_id: video_id, duration: video?.duration)
            }
            .buttonStyle(.plain)
            .overlay {
                if let youTubePlayer {
                    YouTubePlayerView(youTubePlayer) { state in
                        switch state {
                        case .idle:
                            ProgressView()
                        case .ready:
                            EmptyView()
                        case .error:
                            youtubePlayerErrorView
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fit)
                }
            }
            if let video, let action {
                Button {
                    action(video)
                } label: {
                    infosView
                        .padding([.horizontal, .bottom], .medium)
                }
                .buttonStyle(.plain)
            } else {
                infosView
                    .padding([.horizontal, .bottom], .medium)
            }
        }
        .frame(maxWidth: 400)
    }

    private var infosView: some View {
        VStack {
            Group {
                Text(video?.name ?? "")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .top) {
                    Text("\(video?.views ?? 0) views")
                    if let upload_date = video?.upload_date {
                        Text(upload_date, format: .dateTime)
                    }
                    Text(video?.uploader ?? "")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .redacted(reason: video == nil ? .placeholder : [])

            HStack(alignment: .top) {
                TournesolRating(tournesol_score: video?.tournesol_score)
                if let n_comparisons = video?.n_comparisons, let n_contributors = video?.n_contributors {
                    ContributorsRating(n_comparisons: n_comparisons, n_contributors: n_contributors)
                }
                VStack(alignment: .leading) {
                    if let highestCriteria = video?.highestCriteriaScore?.criteria {
                        CriterialLabel("Rated high:", icon: highestCriteria.icon)
                            .labelStyle(.criterialTag)
                    }
                    if let lowestCriteriaScore = video?.lowestCriteriaScore, lowestCriteriaScore.score < 0 {
                        CriterialLabel("Rated low:", icon: lowestCriteriaScore.criteria.icon)
                            .labelStyle(.criterialTag)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var youtubePlayerErrorView: some View {
        VStack {
            Text("YouTube player couldn't be loaded")
                .bold()
                .foregroundStyle(.white)
            if let url = URL(string: Constants.URL.Youtube.ytlink(uid: video_id)) {
                Button("Open in Youtube", systemImage: "play.display") {
                    openURL(url)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(.red)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}
