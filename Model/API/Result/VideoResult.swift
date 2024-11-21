//
//  VideoResult.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct VideoResult: APIResult {
    let collective_rating: CollectiveRating
    public let entity: VideoEntity
}

extension VideoResult: Identifiable {
    public var id: String { entity.id }
}

public extension VideoResult {
    var video_id: String { entity.metadata.video_id }
    var name: String { entity.metadata.name }
    var duration: Duration { .seconds(entity.metadata.duration) }
    var tournesol_score: Double? { collective_rating.tournesol_score }

    var views: Int { entity.metadata.views }
    var upload_date: Date? { ISO8601DateFormatter().date(from: entity.metadata.publication_date) }
    var uploader: String { entity.metadata.uploader }

    var n_comparisons: Int { collective_rating.n_comparisons }
    var n_contributors: Int { collective_rating.n_contributors }

    var criteriaScores: [CriteriaScore]? { collective_rating.criteria_scores }
    var highestCriteriaScore: CriteriaScore? { collective_rating.criteriaScoresWithoutTournesolScore?.max() }
    var lowestCriteriaScore: CriteriaScore? { collective_rating.criteriaScoresWithoutTournesolScore?.min() }
}
