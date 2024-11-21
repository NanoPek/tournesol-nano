//
//  CriterialLabel.swift
//  tournesol
//
//  Created by Jérémie Carrez on 10/04/2024.
//

import SwiftUI

public struct CriterialLabel: View {
    let title: LocalizedStringResource
    let icon: DesignSystem.Icon

    public init(_ title: LocalizedStringResource, icon: DesignSystem.Icon) {
        self.title = title
        self.icon = icon
    }

    public var body: some View {
        Label {
            Text(title)
        } icon: {
            icon.image
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    VStack {
        CriterialLabel("Rated high:", icon: .pedagogy)
        CriterialLabel("Rated low:", icon: .diversityInclusion)
    }
}
