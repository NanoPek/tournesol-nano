//
//  NavigationEnvironment.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import Foundation
import Model

@MainActor
final class NavigationEnvironment: ObservableObject {
    enum Path: Hashable {
        case video(VideoResult)
        case videoInRateLater(VideoResult)
        case compare(VideoResult?, VideoResult?)
        case webView(URL)
        case myRecos(_ username: String)
        case myComparisons
        case myRateLater
    }

    @Published var path: [Path] = []
}
