//
//  tournesolApp.swift
//  tournesol
//
//  Created by Jérémie Carrez on 08/04/2024.
//

import SwiftUI
import AppIntents

@main
struct tournesolApp: App {
    private let videoDetailsNavModel: VideoDetailsNavModel

    @State private var shouldShowTutorial: Bool = false

    init() {
        let videoDetailsNavModel: VideoDetailsNavModel = .init()
        self.videoDetailsNavModel = videoDetailsNavModel
        AppDependencyManager.shared.add(dependency: videoDetailsNavModel)

        if !UserDefaults.standard.bool(forKey: "shouldShowTutorial") {
            UserDefaults.standard.set(true, forKey: "shouldShowTutorial")
            _shouldShowTutorial = State(initialValue: true)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(videoDetailsNavModel: videoDetailsNavModel)
                .sheet(isPresented: $shouldShowTutorial) {
                    TutorialSheet()
                }
        }
    }
}
