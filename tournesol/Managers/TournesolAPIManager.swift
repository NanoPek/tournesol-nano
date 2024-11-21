//
//  TournesolAPIManager.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import Foundation
import Model

final class TournesolAPIManager {
    static let shared = TournesolAPIManager()

    private let tournesolAPIActor: TournesolAPIActor = .init()

    private init() {}

    func getRecommendations(exclude_compared_entities: Bool, limit: Int, offset: Int, language: TournesolLanguage?, date_gte: Date?, sortCriteria: Criteria?, search: String?) async throws -> RecommendationsReponse {
        try await tournesolAPIActor.getRecommendations(
            kind: .reco(exclude_compared_entities: exclude_compared_entities),
            limit: limit,
            offset: offset,
            language: language,
            date_gte: date_gte,
            sortCriteria: sortCriteria,
            search: search
        )
    }

    func getPersonalRecommendations(username: String, limit: Int, offset: Int, language: TournesolLanguage?, date_gte: Date?, search: String?) async throws -> RecommendationsReponse {
        try await tournesolAPIActor.getRecommendations(
            kind: .personalReco(username: username),
            limit: limit,
            offset: offset,
            language: language,
            date_gte: date_gte,
            sortCriteria: nil,
            search: search
        )
    }

    func getRateLaterVideos(limit: Int, offset: Int, search: String?) async throws -> RecommendationsReponse {
        try await tournesolAPIActor.getRecommendations(
            kind: .rateLater(accessToken: try LoginManager.shared.getAccessToken()),
            limit: limit,
            offset: offset,
            language: nil,
            date_gte: nil,
            sortCriteria: nil,
            search: search
        )
    }

    func addRateLater(video_id: String) async throws {
        try await tournesolAPIActor.rateLaterAction(
            .add(video_id: video_id),
            accessToken: try LoginManager.shared.getAccessToken()
        )
    }

    func removeRateLater(video_id: String) async throws {
        try await tournesolAPIActor.rateLaterAction(
            .delete(video_id: video_id),
            accessToken: try LoginManager.shared.getAccessToken()
        )
    }

    func toCompare() async throws -> [VideoResult] {
        try await tournesolAPIActor.toCompare()
    }

    func compare(_ comparison: TComparisonResult) async throws {
        try await tournesolAPIActor.compare(comparison)
    }

    func getMyComparisons(limit: Int) async throws -> ComparisonResponse {
        try await tournesolAPIActor.getMyComparisons(limit: limit)
    }
}

private extension TournesolAPIManager {
    final actor TournesolAPIActor {
        enum RecommendationsKind {
            case reco(exclude_compared_entities: Bool)
            case personalReco(username: String)
            case rateLater(accessToken: String)

            var urlComponents: URLComponents {
                switch self {
                case .reco(let exclude_compared_entities):
                    var components: URLComponents = URLComponents(string: Constants.URL.API.recommendations)!
                    components.queryItems = [
                        URLQueryItem(name: "exclude_compared_entities", value: String(exclude_compared_entities))
                    ]
                    return components
                case .personalReco(let username):
                    return URLComponents(string: Constants.URL.API.personalRecommendations(username))!
                case .rateLater:
                    return URLComponents(string: Constants.URL.API.rateLater)!
                }
            }

            var accessToken: String? {
                switch self {
                case .rateLater(let accessToken):
                    accessToken
                default:
                    nil
                }
            }
        }

        enum RateLaterAction {
            case add(video_id: String)
            case delete(video_id: String)

            var video_id: String {
                switch self {
                case .add(let video_id), .delete(let video_id):
                    video_id
                }
            }

            var url: URL {
                switch self {
                case .add:
                    URL(string: Constants.URL.API.rateLater)!
                case .delete(let video_id):
                    URL(string: Constants.URL.API.deleteRateLater(uid: video_id))!
                }
            }

            var httpMethod: String {
                switch self {
                case .add:
                    "POST"
                case .delete:
                    "DELETE"
                }
            }
        }

        func getRecommendations(kind: RecommendationsKind, limit: Int, offset: Int, language: TournesolLanguage?, date_gte: Date?, sortCriteria: Criteria?, search: String?) async throws -> RecommendationsReponse {
            var components = kind.urlComponents
            if components.queryItems != nil {
                components.queryItems?.append(contentsOf: [
                    URLQueryItem(name: "limit", value: String(limit)),
                    URLQueryItem(name: "offset", value: String(offset))
                ])
            } else {
                components.queryItems = [
                    URLQueryItem(name: "limit", value: String(limit)),
                    URLQueryItem(name: "offset", value: String(offset))
                ]
            }

            switch language {
            case .en:
                components.queryItems?.append(URLQueryItem(name: "metadata[language]", value: "en"))
            case .fr:
                components.queryItems?.append(URLQueryItem(name: "metadata[language]", value: "fr"))
            case nil:
                break
            }

            if let date_gte {
                components.queryItems?.append(URLQueryItem(name: "date_gte", value: date_gte.ISO8601Format()))
            }
            if let sortCriteria {
                components.queryItems?.append(contentsOf: getSortCriteriaURLQueryItems(sortCriteria))
                components.queryItems?.append(URLQueryItem(name: "score_mode", value: "default"))
            }
            if let search {
                components.queryItems?.append(URLQueryItem(name: "search", value: search))
            }
            var request = URLRequest(url: components.url!)

            if let accessToken = kind.accessToken {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
            }

            let (data, _) = try await URLSession.shared.data(for: request)

            return try JSONDecoder().decode(RecommendationsReponse.self, from: data)
        }

        func rateLaterAction(_ kind: RateLaterAction, accessToken: String) async throws {
            var request = URLRequest(url: kind.url)

            request.httpMethod = kind.httpMethod
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")

            if case .add(let video_id) = kind {
                let item = [
                    "entity": [
                        "uid": "yt:\(video_id)"
                    ]
                ]
                let jsonData = try JSONSerialization.data(withJSONObject: item, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

            }

            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case Constants.APIConstants.HttpResponseCode.success:
                    break
                case Constants.APIConstants.HttpResponseCode.conflict:
                    throw AppError.alreadyInList
                case Constants.APIConstants.HttpResponseCode.errorCodesRange:
                    throw AppError.appUnknown(nil)
                default:
                    break
                }
            }
        }

        func toCompare() async throws -> [VideoResult] {
            let token: String = try LoginManager.shared.getAccessToken()

            var components = URLComponents(string: Constants.URL.API.toCompare)!

            components.queryItems = [
                URLQueryItem(name: "strategy", value: "classic")
            ]

            var request = URLRequest(url: components.url!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([VideoResult].self, from: data)
        }

        func compare(_ comparison: TComparisonResult) async throws {
            let token: String = try LoginManager.shared.getAccessToken()

            let url = URL(string: Constants.URL.API.myComparisons)!
            let jsonData = try JSONEncoder().encode(comparison)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
            request.httpBody = jsonData

            _ = try await URLSession.shared.data(for: request)
        }

        func getMyComparisons(limit: Int) async throws -> ComparisonResponse {
            let token: String = try LoginManager.shared.getAccessToken()

            var components = URLComponents(string: Constants.URL.API.myComparisons)!

            components.queryItems = [
                URLQueryItem(name: "limit", value: String(limit))
            ]

            var request = URLRequest(url: components.url!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(ComparisonResponse.self, from: data)
        }
    }
}

// MARK: - Utils -
private extension TournesolAPIManager.TournesolAPIActor {
    func getSortCriteriaURLQueryItems(_ sortCriteria: Criteria) -> [URLQueryItem] {
        Criteria.allCases.sorted().map { criteria in
            URLQueryItem(name: "weights[\(criteria.rawValue)]", value: String(criteria == sortCriteria ? 100 : 0))
        }
    }
}
