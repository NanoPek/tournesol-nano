//
//  TComparisonResult.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

public struct TComparisonResult: APIResult {
    public let entity_a: VideoEntity
    public let entity_b: VideoEntity
    public let entity_a_contexts: [String]
    public let entity_b_contexts: [String]
    public let criteria_scores: [ComparisonCriteriaScore]
    public let duration_ms: Int

    public init(entity_a: VideoEntity, entity_b: VideoEntity, entity_a_contexts: [String], entity_b_contexts: [String], criteria_scores: [ComparisonCriteriaScore], duration_ms: Int) {
        self.entity_a = entity_a
        self.entity_b = entity_b
        self.entity_a_contexts = entity_a_contexts
        self.entity_b_contexts = entity_b_contexts
        self.criteria_scores = criteria_scores
        self.duration_ms = duration_ms
    }
}

extension TComparisonResult: Identifiable {
    public var id: String { entity_a.id + entity_b.id }
}
