//
//  VideoDetailsNavModel.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/08/2024.
//

import Foundation

@MainActor
final class VideoDetailsNavModel: ObservableObject {
    @Published var selectedVideoId: String?
}
