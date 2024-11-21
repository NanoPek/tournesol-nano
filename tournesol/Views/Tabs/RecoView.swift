//
//  RecoView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import SwiftUI

struct RecoView: View {
    @EnvironmentObject private var userEnv: UserEnvironment
    @StateObject private var navEnv: NavigationEnvironment = .init()

    var body: some View {
        NavigationStack(path: $navEnv.path) {
            contentView
                .navigationTitle("Recommendations")
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
        TournesolVideoList(kind: .reco)
    }
}

#Preview {
    RecoView()
}
