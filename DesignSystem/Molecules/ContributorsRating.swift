//
//  ContributorsRating.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import SwiftUI

public struct ContributorsRating: View {
    private let n_comparisons: Int
    private let n_contributors: Int

    public init(n_comparisons: Int, n_contributors: Int) {
        self.n_comparisons = n_comparisons
        self.n_contributors = n_contributors
    }

    public var body: some View {
        Group {
            Text("**\(n_comparisons)** ") +
            Text("comparisons by") +
            Text("\n**\(n_contributors)** ") +
            Text("contributors")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    ContributorsRating(n_comparisons: 98, n_contributors: 33)
}
