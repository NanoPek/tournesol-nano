//
//  RecommendationsReponse.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct RecommendationsReponse: APIResponse {
    let count: Int
    let next: String?
    let previous: String?
    public let results: [VideoResult]
}
