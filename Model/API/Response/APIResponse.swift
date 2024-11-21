//
//  APIResponse.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

protocol APIResponse<Result>: Codable {
    associatedtype Result: Hashable

    var count: Int { get }
    var next: String? { get }
    var previous: String? { get }
    var results: [Result] { get }
}
