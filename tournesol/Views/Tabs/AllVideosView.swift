//
//  AllVideosView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 14/06/2024.
//

import SwiftUI

struct AllVideosView: View {
    @EnvironmentObject private var userEnv: UserEnvironment
    @StateObject private var navEnv: NavigationEnvironment = .init()

    var body: some View {
        NavigationStack(path: $navEnv.path) {
            contentView
                .navigationTitle("All Videos")
                .navigationDestination(for: NavigationEnvironment.Path.self) { path in
                    switch path {
                    case .video(let video):
                        VideoDetailsView(video: video)
                    case .compare(let videoToCompare, _):
                        ComparisonView(video_a: videoToCompare)
                    case .webView(let url):
                        WebView(url: url)
                    default:
                        fatalError("Should not happen")
                    }
                }
        }
        .environmentObject(navEnv)
    }

    var contentView: some View {
        TournesolVideoList(kind: .all)
    }
}

#Preview {
    AllVideosView()
}
