//
//  Constants+Extensions.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 24/08/2024.
//

import Model

extension Constants {
    static let placeholderEntry: WidgetVideoEntry = .init(
        date: .now,
        video: videoPlaceholder,
        thumbnail: .init(named: "thumbnail_placeholder")
    )
    private static let videoPlaceholder: WidgetVideo = .init(
        video_id: "1",
        name: "Is Meat Really that Bad?",
        author: "Kurzgesagt – In a Nutshell",
        uploadDate: .now,
        rating: 57
    )
}
