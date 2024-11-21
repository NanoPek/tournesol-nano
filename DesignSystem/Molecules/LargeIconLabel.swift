//
//  LargeIconLabel.swift
//  tournesol
//
//  Created by Jérémie Carrez on 15/07/2024.
//

import SwiftUI

public struct LargeIconLabel: View {
    let systemImage: String
    let backgroundColor: DesignSystem.Color

    public init(systemImage: String, backgroundColor: DesignSystem.Color) {
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Label {
            Text("")
        } icon: {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 64, height: 64)
                .foregroundStyle(.white)
                .backgroundColor(backgroundColor)
                .cornerRadius(.medium)
        }
        .labelStyle(.iconOnly)
    }
}

#Preview {
    VStack {
        CriterialLabel("Rated high:", icon: .pedagogy)
        CriterialLabel("Rated low:", icon: .diversityInclusion)
    }
}
