//
//  VideoResult+WidgetExtension.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import Foundation
import Model

extension VideoResult {
    func toWidgetVideo() -> WidgetVideo {
        .init(
            video_id: self.video_id,
            name: self.name,
            author: self.uploader,
            uploadDate: self.upload_date,
            rating: self.tournesol_score
        )
    }
}
