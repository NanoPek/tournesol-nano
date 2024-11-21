//
//  Color.swift
//  tournesol
//
//  Created by Jérémie Carrez on 11/04/2024.
//

import SwiftUI

public extension DesignSystem {
    enum Color {
        // App
        case accentColor
        case appBackground
        case surfaceCard

        // Criterias
        case blue
        case purple
        case orange
        case green
        case beige
        case moutard
        case cyan
        case lime
        case red

        var color: SwiftUI.Color {
            switch self {
            case .accentColor:
                    .accentColor
            case .appBackground:
                    .init(.accentLighter)
            case .surfaceCard:
                    .init(.accentLight)
            case .blue:
                    .init(.blue)
            case .purple:
                    .init(.purple)
            case .orange:
                    .init(.orange)
            case .green:
                    .init(.green)
            case .beige:
                    .init(.beige)
            case .moutard:
                    .init(.moutard)
            case .cyan:
                    .init(.cyan)
            case .lime:
                    .init(.lime)
            case .red:
                    .init(.red)
            }
        }
    }
}
