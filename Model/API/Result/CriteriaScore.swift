//
//  CriteriaScore.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct CriteriaScore: APIResult {
    public let criteria: Criteria
    public let score: Double
}

extension CriteriaScore: Identifiable {
    public var id: String { criteria.id }
}

extension CriteriaScore: Comparable {
    public static func < (lhs: CriteriaScore, rhs: CriteriaScore) -> Bool {
        lhs.score < rhs.score
    }
}
