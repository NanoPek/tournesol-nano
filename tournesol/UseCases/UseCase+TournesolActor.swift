//
//  UseCase+TournesolAPIManager.swift
//  tournesol
//
//  Created by Jérémie Carrez on 14/06/2024.
//

import Foundation
import Model

extension UseCase {
    static func getAllVideos(limit: Int, offset: Int, language: TournesolLanguage?, lastDate: Date?, sortCriteria: Criteria?, search: String?) async throws -> [VideoResult] {
        try await TournesolAPIManager.shared.getRecommendations(
            exclude_compared_entities: false,
            limit: limit,
            offset: offset,
            language: language,
            date_gte: lastDate,
            sortCriteria: sortCriteria,
            search: search
        )
        .results
    }

    static func getVideoDetails(video_id: String) async throws -> VideoResult {
        guard let videoDetails = try await TournesolAPIManager.shared.getRecommendations(
            exclude_compared_entities: false,
            limit: 1,
            offset: 0,
            language: nil,
            date_gte: nil,
            sortCriteria: nil,
            search: video_id
        )
            .results.first else {
            throw AppError.appUnknown(nil)
        }
        return videoDetails
    }

    static func getPersonalRecommendations(username: String, limit: Int, offset: Int, language: TournesolLanguage?, lastDate: Date?, search: String) async throws -> [VideoResult] {
        try await TournesolAPIManager.shared.getPersonalRecommendations(
            username: username,
            limit: limit,
            offset: offset,
            language: language,
            date_gte: lastDate,
            search: search
        )
        .results
    }

    static func getRateLaterVideos(limit: Int, offset: Int, search: String) async throws -> [VideoResult] {
        try await TournesolAPIManager.shared.getRateLaterVideos(
            limit: limit,
            offset: offset,
            search: search
        )
        .results
    }

    static func toCompare() async throws -> [VideoResult] {
        try await TournesolAPIManager.shared.toCompare()
    }

    static func compare(entity_a: VideoEntity, entity_b: VideoEntity, score: Int) async throws {
        let comparison: ComparisonCriteriaScore = .init(
            criteria: .largely_recommended,
            score: score,
            score_max: Constants.APIConstants.Comparison.score_max,
            weight: Constants.APIConstants.Comparison.weight
        )
        try await TournesolAPIManager.shared.compare(
            TComparisonResult(
                entity_a: entity_a,
                entity_b: entity_b,
                entity_a_contexts: [],
                entity_b_contexts: [],
                criteria_scores: [comparison],
                duration_ms: 0
            )
        )
    }

    static func getMyComparisons(limit: Int) async throws -> [TComparisonResult] {
        try await TournesolAPIManager.shared.getMyComparisons(limit: limit).results
    }

    static func addToRateLaterList(_ video_id: String) async throws {
        try await TournesolAPIManager.shared.addRateLater(video_id: video_id)
    }

    static func removeFromRateLaterList(_ video_id: String) async throws {
        try await TournesolAPIManager.shared.removeRateLater(video_id: video_id)
    }
}
