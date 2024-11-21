//
//  VideoEntity.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct VideoEntity: APIResult {
    let uid: String
    let type: String
    public let metadata: VideoMetadata
}

extension VideoEntity: Identifiable {
    public var id: String { self.uid }
}

public extension VideoEntity {
    var video_id: String { metadata.video_id }
}
