//
//  ComparisonCriteriaScore.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

public struct ComparisonCriteriaScore: APIResult {
    public let criteria: Criteria
    public let score: Int
    public let score_max: Int
    public let weight: Int

    public init(criteria: Criteria, score: Int, score_max: Int, weight: Int) {
        self.criteria = criteria
        self.score = score
        self.score_max = score_max
        self.weight = weight
    }
}

extension ComparisonCriteriaScore: Identifiable {
    public var id: String { criteria.id }
}

extension ComparisonCriteriaScore: Comparable {
    public static func < (lhs: ComparisonCriteriaScore, rhs: ComparisonCriteriaScore) -> Bool {
        lhs.score < rhs.score
    }
}
