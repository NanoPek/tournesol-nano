//
//  VideoDetailsView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 11/04/2024.
//

import SwiftUI
import Model
import DesignSystem

struct VideoDetailsView: View {
    private let video_id: String

    init(video_id: String) {
        self.video_id = video_id
    }

    init(video: VideoResult) {
        self.video_id = video.video_id
        self._video = .init(initialValue: video)
    }

    @EnvironmentObject private var navEnv: NavigationEnvironment
    @EnvironmentObject private var userEnv: UserEnvironment

    @Environment(\.showError) private var showError

    @State private var video: VideoResult?

    @State private var detailsShown: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        List {
            contentView
                .listRowSeparator(.hidden)
                .listRowBackground(EmptyView())
        }
        .listStyle(.plain)
        .listBackground()
        .toolbar {
            if isLoading {
                ToolbarItem(placement: .topBarTrailing) {
                    ProgressView()
                        .tint(.accentColor)
                }
            }
        }
        .task {
            // Load video details from the API if all info or criteria scores are missing.
            guard video == nil || video?.criteriaScores == nil else { return }
            await getVideoDetails()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        videoSection
        if let criteriaScores = video?.criteriaScores {
            scoreSection(criteriaScores: criteriaScores)
        } else if isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
        }
    }

    private var videoSection: some View {
        Section {
            VideoItem(video_id: video_id, video: video, action: nil)
                .frame(maxWidth: .infinity, alignment: .center)
        } footer: {
            ScrollView(.horizontal) {
                HStack {
                    if userEnv.isLogged {
                        Button("Compare", systemImage: "rectangle.on.rectangle.angled") {
                            navEnv.path.append(.compare(video, nil))
                        }
                        .labelStyle(.titleAndIcon)
                        AddLaterButton(video_id: video_id, onRemoved: nil)
                            .labelStyle(.iconOnly)
                    }
                    if let shareURL = URL(string: Constants.URL.Tournesol.entity(uid: video_id)) {
                        ShareLink(item: shareURL)
                            .labelStyle(.iconOnly)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func scoreSection(criteriaScores: [CriteriaScore]) -> some View {
        Section {
            ForEach(criteriaScores.sorted { $0.criteria < $1.criteria }) { criteriaScore in
                CriterialProgress(
                    criteria: criteriaScore.criteria,
                    score: criteriaScore.score,
                    detailsShown: detailsShown
                )
            }
        } header: {
            HStack {
                Text("Scores per criterion")
                Button(
                    "More details",
                    systemImage: detailsShown ? "chevron.right.circle" : "chevron.down.circle"
                ) {
                    withAnimation {
                        detailsShown.toggle()
                    }
                }
                .labelStyle(.iconOnly)
            }
        }
    }
}

// MARK: - Private functions -
private extension VideoDetailsView {
    func getVideoDetails() async {
        defer { isLoading = false }
        isLoading = true
        do {
            self.video = try await UseCase.getVideoDetails(video_id: video_id)
        } catch {
            showError(error)
        }
    }
}
