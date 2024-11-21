//
//  ComparisonViewModel.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

import Foundation
import Combine
import Model

@MainActor
final class ComparisonViewModel: ObservableObject {
    @Published var sliderValue: Double = 0

    @Published private(set) var video_a: VideoResult?
    @Published private(set) var video_b: VideoResult?

    @Published private var videosToCompare: [VideoResult] = []

    @Published private(set) var isVideosToCompareLoading: Bool = false
    @Published private(set) var isComparisonSuccess: Bool = false

    private var cancellable: AnyCancellable?

    init(video_a: VideoResult?, video_b: VideoResult?) {
        self.video_a = video_a
        self.video_b = video_b

        observeVideosToCompare()
    }

    func refresh(forceRefresh: Bool = false) async throws {
        if forceRefresh {
            try await refreshVideosToCompare()
            sliderValue = 0
        }

        if video_a == nil {
            video_a = refreshVideo(otherVideoCompared: video_b)
        }
        if video_b == nil || forceRefresh {
            video_b = refreshVideo(otherVideoCompared: video_a)
        }
    }

    func refreshVideoA() {
        video_a = refreshVideo(otherVideoCompared: video_b)
    }

    func refreshVideoB() {
        video_b = refreshVideo(otherVideoCompared: video_a)
    }

    func compare() async throws {
        guard let video_a, let video_b else { return }
        try await UseCase.compare(
            entity_a: video_a.entity,
            entity_b: video_b.entity,
            score: Int(sliderValue)
        )
        try await afterComparisonSuccess()
    }
}

// MARK: - Private functions -
private extension ComparisonViewModel {
    func observeVideosToCompare() {
        cancellable = $videosToCompare
            .removeDuplicates()
            .sink { [weak self] videosToCompare in
                if videosToCompare.isEmpty {
                    Task {
                        try await self?.refreshVideosToCompare()
                    }
                } else {
                    if self?.video_a == nil {
                        self?.video_a = self?.refreshVideo(otherVideoCompared: self?.video_b)
                    }
                    if self?.video_b == nil {
                        self?.video_b = self?.refreshVideo(otherVideoCompared: self?.video_a)
                    }
                }
            }
    }

    func refreshVideosToCompare() async throws {
        isVideosToCompareLoading = true
        defer { isVideosToCompareLoading = false }
        videosToCompare = try await UseCase.toCompare()
    }

    func refreshVideo(otherVideoCompared: VideoResult?) -> VideoResult? {
        let nextVideo: VideoResult? = videosToCompare.popLast()
        if let nextVideo, let otherVideoCompared, nextVideo.video_id == otherVideoCompared.video_id {
            return refreshVideo(otherVideoCompared: otherVideoCompared)
        }
        return nextVideo
    }

    func afterComparisonSuccess() async throws {
        isComparisonSuccess = true
        try await Task.sleep(nanoseconds: 3_000_000_000)
        isComparisonSuccess = false
        try await refresh(forceRefresh: true)
    }
}
