//
//  TournesolVideoList.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import SwiftUI
import Combine
import Model
import DesignSystem

struct TournesolVideoList<NavModel: NavigationEnvironment>: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.showError) private var showError
    @Environment(\.isRateLater) private var isRateLater

    @EnvironmentObject private var navEnv: NavModel
    @EnvironmentObject private var userEnv: UserEnvironment

    @StateObject private var viewModel: TournesolVideoListViewModel

    init(kind: TournesolVideoListViewModel.Kind) {
        self._viewModel = .init(wrappedValue: .init(kind: kind))
    }

    var body: some View {
        listView
            .toolbar {
                if viewModel.isFetching && !viewModel.tournesolVideos.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        ProgressView()
                            .tint(.accentColor)
                    }
                }
            }
            .toolbar {
                if viewModel.kind.isFilterable {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Sort by...", systemImage: "arrow.up.arrow.down", selection: $viewModel.selectedSortCriteria) {
                                ForEach(Criteria.allCases.sorted()) { criteria in
                                    CriterialLabel(criteria.description, icon: criteria.icon).tag(Optional(criteria))
                                }
                            }
                            Picker("Uploaded...", systemImage: "calendar", selection: $viewModel.selectedDateFilter) {
                                ForEach(TournesolVideoListViewModel.DateFilter.allCases) { dateFilter in
                                    Text(dateFilter.description).tag(dateFilter)
                                }
                            }
                            Picker("Language", systemImage: "globe", selection: $viewModel.selectedLanguage) {
                                ForEach(TournesolLanguage.allCases) { language in
                                    Text(language.description).tag(Optional(language))
                                }
                                Text("All").tag(nil as TournesolLanguage?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .overlay {
                if viewModel.tournesolVideos.isEmpty {
                    if viewModel.isFetching {
                        ProgressView()
                    } else {
                        noVideosView
                    }
                }
            }
            .task(viewModel.refresh)
            .refreshable(action: viewModel.refresh)
            .onChange(of: viewModel.error != nil) { _ in
                if let error = viewModel.error {
                    showError(error)
                }
            }
    }

    private var listView: some View {
        List {
            ForEach(Array(viewModel.tournesolVideos.enumerated()), id: \.1) { index, video in
                VideoItem(video: video) {
                    if isRateLater {
                        navEnv.path.append(.videoInRateLater($0))
                    } else {
                        navEnv.path.append(.video($0))
                    }
                }
                .contextMenu {
                    if let shareURL = URL(string: Constants.URL.Tournesol.entity(uid: video.video_id)) {
                        ShareLink(item: shareURL)
                    }
                    if let url = URL(string: Constants.URL.Youtube.ytlink(uid: video.video_id)) {
                        Button("Open in Youtube", systemImage: "play.display") {
                            openURL(url)
                        }
                    }
                    if userEnv.isLogged {
                        Button("Compare now", systemImage: "rectangle.on.rectangle.angled") {
                            navEnv.path.append(.compare(video, nil))
                        }
                        AddLaterButton(video_id: video.video_id, onRemoved: viewModel.refresh)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(EmptyView())
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    viewModel.triggerNewSearchIfNeeded(index: index, video: video)
                }
            }
        }
        .listStyle(.plain)
        .listBackground()
        .scrollIndicators(.hidden)
    }

    private var noVideosView: some View {
        Text("Could not find any videos.")
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

private extension Constants {
    static let listRowBackground: Color = .init(UIColor.systemGray6)
}
