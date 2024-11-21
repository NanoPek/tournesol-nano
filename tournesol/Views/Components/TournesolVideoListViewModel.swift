//
//  TournesolVideoListViewModel.swift
//  tournesol
//
//  Created by Jérémie Carrez on 14/06/2024.
//

import Foundation
import Combine
import Model

final class TournesolVideoListViewModel: ObservableObject {
    let kind: Kind

    @Published var searchText: String = ""
    @Published var selectedSortCriteria: Criteria?
    @Published var selectedDateFilter: DateFilter
    @Published var selectedLanguage: TournesolLanguage?

    @Published private(set) var isFetching: Bool = true
    @Published private(set) var error: Error?
    @Published private(set) var tournesolVideos: [VideoResult] = []
    @Published private(set) var offset: Int = 0

    private var cancellables: [AnyCancellable] = []

    init(kind: Kind) {
        self.kind = kind
        self.selectedDateFilter = kind.defaultDateFilter

        $selectedLanguage
            .combineLatest(
                $searchText.debounce(for: Constants.triggerAfterSearchTextChangeDelay, scheduler: RunLoop.main),
                $selectedDateFilter,
                $selectedSortCriteria
            )
            .dropFirst()
            .sink { [weak self] selectedLanguage, search, selectedDateFilter, selectedSortCriteria in
                self?.refreshAfterChange(
                    search: search,
                    selectedLanguage: selectedLanguage,
                    lastDate: selectedDateFilter.associatedDate,
                    selectedSortCriteria: selectedSortCriteria
                )
            }
            .store(in: &cancellables)
    }

    @Sendable
    func refresh() async {
        await getVideos(
            search: searchText,
            selectedLanguage: selectedLanguage,
            lastDate: selectedDateFilter.associatedDate,
            sortCriteria: selectedSortCriteria
        )
    }

    func triggerNewSearchIfNeeded(index: Int, video: VideoResult) {
        guard index == offset + Constants.limit - Constants.triggerNewSearchOffset || video == tournesolVideos.last else { return }
        Task {
            await getNextVideos()
        }
    }
}

private extension TournesolVideoListViewModel {
    func refreshAfterChange(search: String, selectedLanguage: TournesolLanguage?, lastDate: Date?, selectedSortCriteria: Criteria?) {
        Task {
            await getVideos(
                search: search,
                selectedLanguage: selectedLanguage,
                lastDate: lastDate,
                sortCriteria: selectedSortCriteria
            )
        }
    }

    @MainActor
    func getVideos(search: String, selectedLanguage: TournesolLanguage?, lastDate: Date?, sortCriteria: Criteria?) async {
        isFetching = true
        defer { isFetching = false }
        do {
            switch kind {
            case .reco, .all:
                tournesolVideos = try await UseCase.getAllVideos(
                    limit: Constants.limit,
                    offset: 0,
                    language: selectedLanguage,
                    lastDate: lastDate,
                    sortCriteria: sortCriteria,
                    search: searchText
                )
            case .perso(let username):
                tournesolVideos = try await UseCase.getPersonalRecommendations(
                    username: username,
                    limit: Constants.limit,
                    offset: 0,
                    language: selectedLanguage,
                    lastDate: lastDate,
                    search: searchText
                )
            case .rateLater:
                tournesolVideos = try await UseCase.getRateLaterVideos(
                    limit: Constants.limit,
                    offset: 0,
                    search: searchText
                )
            }
            offset += Constants.limit
        } catch {
            self.error = error
        }
    }

    @MainActor
    func getNextVideos() async {
        isFetching = true
        defer { isFetching = false }
        do {
            var newVideos: [VideoResult] = []
            switch kind {
            case .reco, .all:
                newVideos = try await UseCase.getAllVideos(
                    limit: Constants.limit,
                    offset: offset,
                    language: selectedLanguage,
                    lastDate: selectedDateFilter.associatedDate,
                    sortCriteria: selectedSortCriteria,
                    search: searchText
                )
            case .perso(let username):
                newVideos = try await UseCase.getPersonalRecommendations(
                    username: username,
                    limit: Constants.limit,
                    offset: offset,
                    language: selectedLanguage,
                    lastDate: selectedDateFilter.associatedDate,
                    search: searchText
                )
            case .rateLater:
                newVideos = try await UseCase.getRateLaterVideos(
                    limit: Constants.limit,
                    offset: offset,
                    search: searchText
                )
            }
            offset += Constants.limit
            tournesolVideos += newVideos
        } catch {
            self.error = error
        }
    }
}

// MARK: - Enums -
extension TournesolVideoListViewModel {
    enum Kind: Equatable {
        case reco
        case all
        case perso(_ username: String)
        case rateLater

        var isFilterable: Bool {
            switch self {
            case .reco, .all, .perso:
                true
            case .rateLater:
                false
            }
        }

        var defaultDateFilter: DateFilter {
            switch self {
            case .reco:
                .lastMonth
            default:
                .all
            }
        }
    }

    enum DateFilter: String, Identifiable, Hashable, CaseIterable {
        case lastDay
        case lastWeek
        case lastMonth
        case lastYear
        case all

        var id: String { self.rawValue }

        var description: LocalizedStringResource {
            switch self {
            case .lastDay:
                "A day ago"
            case .lastWeek:
                "A week ago"
            case .lastMonth:
                "A month ago"
            case .lastYear:
                "A year ago"
            case .all:
                "All time"
            }
        }

        var associatedDate: Date? {
            switch self {
            case .lastDay:
                Calendar.current.date(byAdding: .day, value: -1, to: Date())
            case .lastWeek:
                Calendar.current.date(byAdding: .day, value: -7, to: Date())
            case .lastMonth:
                Calendar.current.date(byAdding: .month, value: -1, to: Date())
            case .lastYear:
                Calendar.current.date(byAdding: .year, value: -1, to: Date())
            case .all:
                nil
            }
        }
    }
}

private extension Constants {
    static let limit: Int = 30
    static let triggerNewSearchOffset: Int = 15
    static let triggerAfterSearchTextChangeDelay: RunLoop.SchedulerTimeType.Stride = 0.2
}
