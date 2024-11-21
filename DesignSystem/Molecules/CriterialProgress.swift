//
//  CriterialProgress.swift
//  DesignSystem
//
//  Created by Jérémie Carrez on 06/08/2024.
//

import SwiftUI

public struct CriterialProgress: View {
    private let description: LocalizedStringResource
    private let icon: DesignSystem.Icon

    private let score: Double
    private let color: DesignSystem.Color

    private let detailsShown: Bool

    public init(description: LocalizedStringResource, icon: DesignSystem.Icon, score: Double, color: DesignSystem.Color, detailsShown: Bool) {
        self.description = description
        self.icon = icon
        self.score = score
        self.color = color
        self.detailsShown = detailsShown
    }

    public var body: some View {
        HStack {
            CriterialLabel(description, icon: icon)
                .frame(width: Constants.iconSize, height: Constants.iconSize)
                .labelStyle(.iconOnly)
            if detailsShown {
                Text(description)
                    .layoutPriority(1)
            }
            ProgressView(
                value: abs(score),
                total: Constants.maxScore
            )
            .tint(score >= 0 ? color : .red)
            Text("\(Int(score))")
                .layoutPriority(1)
        }
        .foregroundStyle(score >= 0 ? color : .red)
        .bold()
        .lineLimit(1)
    }
}

private enum Constants {
    static let iconSize: CGFloat = 30
    static let maxScore: Double = 100
}

#Preview {
    List {
        Group {
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: 0,
                color: .purple,
                detailsShown: false
            )
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: 50,
                color: .purple,
                detailsShown: false
            )
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: 100,
                color: .purple,
                detailsShown: false
            )
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: 100,
                color: .purple,
                detailsShown: true
            )
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: -50,
                color: .purple,
                detailsShown: false
            )
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: -100,
                color: .purple,
                detailsShown: false
            )
            CriterialProgress(
                description: "Clear & pedagogical",
                icon: .pedagogy,
                score: -100,
                color: .purple,
                detailsShown: true
            )
        }
        .listRowBackground(EmptyView())
        .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .listBackground()
}
