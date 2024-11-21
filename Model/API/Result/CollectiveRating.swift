//
//  CollectiveRating.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct CollectiveRating: APIResult {
    let criteria_scores: [CriteriaScore]?
    let n_comparisons: Int
    let n_contributors: Int
    let tournesol_score: Double?
}

extension CollectiveRating {
    var criteriaScoresWithoutTournesolScore: [CriteriaScore]? { criteria_scores?.filter { $0.criteria != .largely_recommended } }
}
