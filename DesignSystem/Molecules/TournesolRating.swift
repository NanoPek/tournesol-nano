//
//  TournesolRating.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import SwiftUI

public struct TournesolRating: View {
    private let tournesol_score: Double?

    public init(tournesol_score: Double?) {
        self.tournesol_score = tournesol_score
    }

    public var body: some View {
        HStack {
            Image(.tournesol)
                .resizable()
                .scaledToFit()
            Text(String(Int(tournesol_score ?? 50)))
                .font(.title)
                .bold()
                .redacted(reason: tournesol_score == nil ? .placeholder : [])
        }
        .fixedSize()
    }
}

#Preview {
    TournesolRating(tournesol_score: 53.2)
}
