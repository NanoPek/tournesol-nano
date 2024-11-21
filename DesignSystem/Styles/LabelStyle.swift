//
//  LabelStyle.swift
//  tournesol
//
//  Created by Jérémie Carrez on 10/04/2024.
//

import SwiftUI

public extension LabelStyle where Self == CriterialLabelStyle {
    static var criterialTag: CriterialLabelStyle {
        CriterialLabelStyle()
    }
}

public struct CriterialLabelStyle: LabelStyle {
    @ScaledMetric(relativeTo: .footnote) private var iconWidth: CGFloat = 14

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 2) {
            configuration.title
                .font(.footnote)
                .foregroundStyle(.secondary)
            configuration.icon
                .frame(width: iconWidth)
        }
    }
}
