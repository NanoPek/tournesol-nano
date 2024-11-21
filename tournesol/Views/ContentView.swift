//
//  ContentView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 08/04/2024.
//

import SwiftUI
import Model

struct VideoToDetail: Identifiable {
    var id: String { video_id }
    let video_id: String
}

struct ContentView: View {
    @StateObject private var userEnv: UserEnvironment = .init()
    @ObservedObject private var videoDetailsNavModel: VideoDetailsNavModel

    @State private var videoIDToPresent: VideoToDetail?
    @State private var appError: AppError?

    init(videoDetailsNavModel: VideoDetailsNavModel) {
        self.videoDetailsNavModel = videoDetailsNavModel
    }

    var body: some View {
        TabView {
            RecoView()
                .tabItem {
                    Label("Recommendations", systemImage: "star")
                }

            AllVideosView()
                .tabItem {
                    Label("All Videos", systemImage: "play.rectangle")
                }

            MyProfileView()
                .tabItem {
                    Label("My Profile", systemImage: "person")
                }
        }
        .onReceive(videoDetailsNavModel.$selectedVideoId) { video_id in
            guard let video_id else { return }
            self.videoIDToPresent = .init(video_id: video_id)
        }
        .sheet(item: $videoIDToPresent) { videoIDToPresent in
            NavigationStack {
                VideoDetailsView(video_id: videoIDToPresent.video_id)
                    .navigationTitle("Video Details")
            }
        }
        .sheet(item: $appError) {
            ErrorView(appError: $0)
        }
        .environmentObject(userEnv)
        .environment(\.showError, { showError(appError: $0.toAppError) })
        .task {
            do {
                try await userEnv.loginFromKeyChain()
            } catch {
                appError = .failedToRefreshToken
            }
        }
    }
}

private extension ContentView {
    func showError(appError: AppError) {
        if case let .appUnknown(error) = appError {
            print("❌ Unknown Error:", error)
        } else {
            print("❌ Error:", appError.localizedDescription)
            self.appError = appError
        }
    }
}

#Preview {
    ContentView(videoDetailsNavModel: .init())
}
