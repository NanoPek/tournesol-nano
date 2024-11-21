//
//  VideoMetadata.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct VideoMetadata: APIResult {
    let channel_id: String
    let description: String
    public let duration: Int
    let is_unlisted: Bool
    let language: String
    public let name: String
    let publication_date: String
    let source: String
    let tags: [String]
    let uploader: String
    let video_id: String
    let views: Int
}
