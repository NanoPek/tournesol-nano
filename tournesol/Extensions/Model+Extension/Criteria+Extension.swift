//
//  Criteria+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import Foundation
import Model
import DesignSystem

extension Criteria {
    var color: DesignSystem.Color {
        switch self {
        case .backfire_risk:
            .red
        case .better_habits:
            .lime
        case .diversity_inclusion:
            .cyan
        case .engaging:
            .moutard
        case .entertaining_relaxing:
            .beige
        case .importance:
            .orange
        case .largely_recommended:
            .accentColor
        case .layman_friendly:
            .green
        case .pedagogy:
            .purple
        case .reliability:
            .blue
        }
    }

    var description: LocalizedStringResource {
        switch self {
        case .backfire_risk:
            "Resilience to backfiring risks"
        case .better_habits:
            "Encourages better habits"
        case .diversity_inclusion:
            "Diveristy & inclusion"
        case .engaging:
            "Engaging & thought-provoking"
        case .entertaining_relaxing:
            "Entertaining & relaxing"
        case .importance:
            "Important & actionable"
        case .largely_recommended:
            "Should be largely recommended"
        case .layman_friendly:
            "Layman-friendly"
        case .pedagogy:
            "Clear & pedagogical"
        case .reliability:
            "Reliable & not missleading"
        }
    }

    var icon: DesignSystem.Icon {
        switch self {
        case .backfire_risk:
                .backfireRisk
        case .better_habits:
                .betterHabits
        case .diversity_inclusion:
                .diversityInclusion
        case .engaging:
                .engaging
        case .entertaining_relaxing:
                .entertainingRelaxing
        case .importance:
                .importance
        case .largely_recommended:
                .largelyRecommended
        case .layman_friendly:
                .laymanFriendly
        case .pedagogy:
                .pedagogy
        case .reliability:
                .reliability
        }
    }
}
