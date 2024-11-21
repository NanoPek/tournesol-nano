//
//  RecoWidgetProvider.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 23/08/2024.
//

import UIKit
import WidgetKit
import Model

struct RecoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetVideoEntry {
        Constants.placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetVideoEntry) -> Void) {
        getDailyVideo { dailyVideo in
            if let dailyVideo {
                Task {
                    var thumbnail: UIImage?
                    if let url: URL = .init(string: Constants.URL.Youtube.ytPreview(uid: dailyVideo.video_id)) {
                        thumbnail = await downloadImage(from: url)
                    }
                    let entry: WidgetVideoEntry = .init(date: .now, video: dailyVideo, thumbnail: thumbnail)
                    completion(entry)
                }
            } else {
                completion(Constants.placeholderEntry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        getDailyVideo { dailyVideo in
            Task {
                var thumbnail: UIImage?
                if let video_id = dailyVideo?.video_id, let url = URL(string: Constants.URL.Youtube.ytPreview(uid: video_id)) {
                    thumbnail = await downloadImage(from: url)
                }
                let entry: WidgetVideoEntry = .init(date: .now, video: dailyVideo, thumbnail: thumbnail)
                let timeline = Timeline(entries: [entry], policy: .after(.tomorrowMidnight))
                completion(timeline)
            }
        }
    }
}

private extension RecoWidgetProvider {
    func getDailyVideo(completion: @escaping (WidgetVideo?) -> Void) {
        Task {
            guard let widgetVideo: WidgetVideo = try await WidgetUseCase.getDailyRecommendation() else {
                completion(nil)
                return
            }
            completion(widgetVideo)
        }
    }

    func downloadImage(from url: URL) async -> UIImage? {
        guard let response = try? await URLSession.shared.data(from: url) else { return nil }
        return UIImage(data: response.0)
    }
}
