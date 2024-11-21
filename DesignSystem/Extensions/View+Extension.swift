//
//  View+Extension.swift
//  DesignSystem
//
//  Created by Jérémie Carrez on 06/08/2024.
//

import SwiftUI
import WidgetKit

public extension View {
    func padding(_ spacing: DesignSystem.Spacing) -> some View {
        padding(.all, spacing.rawValue)
    }
    func padding(_ edges: Edge.Set = .all, _ spacing: DesignSystem.Spacing) -> some View {
        padding(edges, spacing.rawValue)
    }

    func backgroundColor(_ color: DesignSystem.Color) -> some View {
        background(color.color)
    }

    func foregroundStyle(_ color: DesignSystem.Color) -> some View {
        foregroundStyle(color.color)
    }

    func tint(_ color: DesignSystem.Color) -> some View {
        tint(color.color)
    }

    func listRowBackground(_ color: DesignSystem.Color) -> some View {
        listRowBackground(color.color)
    }

    func listBackground() -> some View {
        self
            .backgroundColor(.appBackground)
            .scrollContentBackground(.hidden)
    }

    func cornerRadius(_ cornerRadius: DesignSystem.CornerRadius) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius.rawValue))
    }

    @available(iOS 17.0, *)
    func containerBackgroundColor(_ color: DesignSystem.Color) -> some View {
        containerBackground(color.color, for: .widget)
    }
}
