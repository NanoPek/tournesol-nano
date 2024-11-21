//
//  TutorialRow.swift
//  DesignSystem
//
//  Created by Jérémie Carrez on 14/11/2024.
//

import SwiftUI

public struct TutorialRow: View {
    private let headline: LocalizedStringResource
    private let description: LocalizedStringResource
    private let systemName: String
    private let iconColor: DesignSystem.Color

    public init(headline: LocalizedStringResource, description: LocalizedStringResource, systemName: String, iconColor: DesignSystem.Color = .accentColor) {
        self.headline = headline
        self.description = description
        self.systemName = systemName
        self.iconColor = iconColor
    }

    public var body: some View {
        HStack {
            Image(systemName: systemName)
                .font(.title)
                .foregroundStyle(iconColor)
            VStack(alignment: .leading) {
                Text(headline)
                    .font(.headline)
                Text(description)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    TutorialRow(
        headline: "Watch YouTube from the App",
        description: "Watch all the community recommended videos directly from the app, without ads",
        systemName: "play.display",
        iconColor: .red
    )
}
