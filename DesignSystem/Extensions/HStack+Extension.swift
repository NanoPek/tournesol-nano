//
//  HStack+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 14/11/2024.
//

import SwiftUI

public extension HStack {
    init(
        alignment: VerticalAlignment = .center,
        spacing: DesignSystem.Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}
