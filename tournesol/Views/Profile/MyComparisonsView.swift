//
//  MyComparisonsView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

import SwiftUI
import Model
import DesignSystem

struct MyComparisonsView: View {
    @Environment(\.showError) private var showError
    @EnvironmentObject private var navEnv: NavigationEnvironment

    @State private var myComparisons: [TComparisonResult] = []

    var body: some View {
        contentView
            .navigationTitle("My comparisons")
            .task {
                do {
                    myComparisons = try await UseCase.getMyComparisons(limit: 100)
                } catch {
                    showError(error)
                }
            }
    }

    private var contentView: some View {
        List {
            ForEach(myComparisons) { comparison in
                comparisonButton(video_a: comparison.entity_a, video_b: comparison.entity_b)
                    .listRowBackground(.surfaceCard)
            }
        }
        .listBackground()
    }

    @ViewBuilder
    private func comparisonButton(video_a: VideoEntity, video_b: VideoEntity) -> some View {
        if let url = URL(
            string: Constants.URL.Tournesol.comparison(
                uidA: video_a.video_id,
                uidB: video_b.video_id
            )
        ) {
            Button {
                navEnv.path.append(.webView(url))
            } label: {
                comparisonView(video_a: video_a, video_b: video_b)
            }
            .buttonStyle(.plain)
        } else {
            comparisonView(video_a: video_a, video_b: video_b)
        }
    }

    private func comparisonView(video_a: VideoEntity, video_b: VideoEntity) -> some View {
        VStack {
            HStack(alignment: .top) {
                VStack {
                    ThumbnailView(video_id: video_a.video_id, duration: .seconds(video_a.metadata.duration))
                    Text(video_a.metadata.name)
                }
                Spacer()
                VStack {
                    ThumbnailView(video_id: video_b.video_id, duration: .seconds(video_b.metadata.duration))
                    Text(video_b.metadata.name)
                }
            }
            .font(.headline)
            .bold()
            .lineLimit(2)
            .minimumScaleFactor(0.8)
        }
    }
}
