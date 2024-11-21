//
//  ComparisonResponse.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

public struct ComparisonResponse: APIResponse {
    let count: Int
    let next: String?
    let previous: String?
    public let results: [TComparisonResult]
}
