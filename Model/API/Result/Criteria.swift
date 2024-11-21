//
//  Criteria.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

@frozen
public enum Criteria: String, CaseIterable, APIResult {
    case backfire_risk
    case better_habits
    case diversity_inclusion
    case engaging
    case entertaining_relaxing
    case importance
    case largely_recommended
    case layman_friendly
    case pedagogy
    case reliability

    private var order: Int {
        switch self {
        case .backfire_risk:
            9
        case .better_habits:
            8
        case .diversity_inclusion:
            7
        case .engaging:
            6
        case .entertaining_relaxing:
            5
        case .importance:
            3
        case .largely_recommended:
            0
        case .layman_friendly:
            4
        case .pedagogy:
            2
        case .reliability:
            1
        }
    }
}

extension Criteria: Identifiable {
    public var id: String { self.rawValue }
}

extension Criteria: Comparable {
    public static func < (lhs: Criteria, rhs: Criteria) -> Bool {
        lhs.order < rhs.order
    }
}
