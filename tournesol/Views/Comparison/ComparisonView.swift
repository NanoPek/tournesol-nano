//
//  ComparisonView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

import SwiftUI
import Model
import DesignSystem

struct ComparisonView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.showError) private var showError
    @EnvironmentObject private var navEnv: NavigationEnvironment

    @StateObject private var viewModel: ComparisonViewModel

    @State private var isLoading: Bool = false

    init(video_a: VideoResult? = nil, video_b: VideoResult? = nil) {
        self._viewModel = .init(wrappedValue: .init(video_a: video_a, video_b: video_b))
    }

    var body: some View {
        contentView
            .navigationTitle("Submit a comparison")
            .toolbar {
                if let uidA = viewModel.video_a?.video_id,
                   let url = URL(string: Constants.URL.Tournesol.comparison(uidA: uidA, uidB: viewModel.video_b?.video_id)) {
                    ToolbarItem(placement: .secondaryAction) {
                        Button("Advanced comparison", systemImage: "safari") {
                            navEnv.path.append(.webView(url))
                        }
                    }
                }
            }
            .refreshable {
                do {
                    try await viewModel.refresh(forceRefresh: true)
                } catch {
                    showError(error)
                }
            }
            .task {
                do {
                    try await viewModel.refresh()
                } catch {
                    showError(error)
                }
            }
    }

    private var contentView: some View {
        List {
            videoSection(
                viewModel.video_a,
                title: "Video A",
                refresh: viewModel.refreshVideoA
            )
            .animation(.default, value: viewModel.video_a)
            videoSection(
                viewModel.video_b,
                title: "Video B",
                refresh: viewModel.refreshVideoB
            )
            .animation(.default, value: viewModel.video_b)
            rateSection
                .animation(.default, value: isLoading)
        }
        .listStyle(.sidebar)
        .listBackground()
        .animation(.default, value: viewModel.isVideosToCompareLoading)
        .animation(.default, value: viewModel.isComparisonSuccess)
    }
}

// MARK: - Sections -
private extension ComparisonView {
    func videoSection(_ video: VideoResult?, title: String, refresh: @escaping () -> Void) -> some View {
        Section {
            Button("Auto", systemImage: "arrow.triangle.2.circlepath", action: refresh)
                .buttonStyle(.borderedProminent)
                .labelStyle(.titleAndIcon)
            if let video {
                VideoItem(video: video, action: nil)
            } else {
                RoundedRectangle(cornerRadius: .small)
                    .fill(.surfaceCard)
                    .overlay { ProgressView() }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fit)
            }
        } header: {
            Text(title)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(EmptyView())
    }

    var rateSection: some View {
        Section {
            HStack {
                VStack(alignment: .leading) {
                    Text("Video A")
                        .bold()
                    if let video_a = viewModel.video_a {
                        Text(video_a.name)
                            .font(.footnote)
                    }
                }
                .multilineTextAlignment(.leading)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Video B")
                        .bold()
                    if let video_b = viewModel.video_b {
                        Text(video_b.name)
                            .font(.footnote)
                    }
                }
                .multilineTextAlignment(.trailing)
            }
            Slider(
                value: $viewModel.sliderValue,
                in: Double(Constants.APIConstants.Comparison.score_min)...Double(Constants.APIConstants.Comparison.score_max),
                step: Constants.step
            )
            .tint(.accentColor )
        } header: {
            CriterialLabel(Criteria.largely_recommended.description, icon: Criteria.largely_recommended.icon)
                .frame(height: Constants.iconHeight)
        } footer: {
            footerView
                .frame(maxWidth: .infinity)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(.surfaceCard)
    }

    @ViewBuilder
    private var footerView: some View {
        if viewModel.isComparisonSuccess {
            Text("Successful comparison ✅, thank you!")
                .foregroundStyle(.green)
        } else {
            Button("Compare videos", systemImage: "rectangle.on.rectangle.angled") {
                Task {
                    isLoading = true
                    defer { isLoading = false }
                    do {
                        try await viewModel.compare()
                    } catch {
                        showError(error)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .labelStyle(.titleAndIcon)
            .disabled(viewModel.video_a == nil || viewModel.video_b == nil || isLoading)
        }
    }
}

private extension Constants {
    static let step: Double = 1
    static let iconHeight: CGFloat = 20
}
