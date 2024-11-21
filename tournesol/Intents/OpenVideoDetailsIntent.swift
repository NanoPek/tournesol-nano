//
//  OpenVideoDetailsIntent.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/08/2024.
//

import AppIntents

struct OpenVideoDetailsIntent: AppIntent {
    static let title: LocalizedStringResource = "Open a Video details"
    static var description: IntentDescription = .init("Opens a Video details in app.")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Video")
    var video_id: String

    init(video_id: String) {
        self.video_id = video_id
    }

    init() {}

    @MainActor
    func perform() async throws -> some IntentResult {
        navModel.selectedVideoId = video_id
        return  .result()
    }

    @Dependency
    private var navModel: VideoDetailsNavModel
}
