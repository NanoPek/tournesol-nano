//
//  Icon.swift
//  DesignSystem
//
//  Created by Jérémie Carrez on 13/04/2024.
//

import Foundation
import SwiftUI

public extension DesignSystem {
    enum Icon: String, Identifiable, CaseIterable {
        case tournesol

        // Criterias
        case backfireRisk
        case betterHabits
        case diversityInclusion
        case engaging
        case entertainingRelaxing
        case importance
        case largelyRecommended
        case laymanFriendly
        case pedagogy
        case reliability

        public var image: Image {
            switch self {
            case .tournesol:
                Image(.tournesol)
            case .backfireRisk:
                Image(.backfireRisk)
            case .betterHabits:
                Image(.betterHabits)
            case .diversityInclusion:
                Image(.diversityInclusion)
            case .engaging:
                Image(.engaging)
            case .entertainingRelaxing:
                Image(.entertainingRelaxing)
            case .importance:
                Image(.importance)
            case .largelyRecommended:
                Image(.largelyRecommended)
            case .laymanFriendly:
                Image(.laymanFriendly)
            case .pedagogy:
                Image(.pedagogy)
            case .reliability:
                Image(.reliability)
            }
        }

        public var id: String { self.rawValue }
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
            ForEach(DesignSystem.Icon.allCases) { value in
                value.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
        }
    }
}
