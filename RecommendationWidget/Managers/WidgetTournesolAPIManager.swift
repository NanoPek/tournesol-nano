//
//  WidgetTournesolAPIManager.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import Foundation
import Model

final class WidgetTournesolAPIManager {
    static let shared = WidgetTournesolAPIManager()

    private init() {}

    func getRecommendation(limit: Int, date_gte: Date, language: TournesolLanguage?) async throws -> RecommendationsReponse {
        guard var components: URLComponents = .init(string: "https://api.tournesol.app/polls/videos/recommendations") else { throw WidgetError.invalidUrl }
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "date_gte", value: date_gte.ISO8601Format())
        ]

        switch language {
        case .en:
            components.queryItems?.append(URLQueryItem(name: "metadata[language]", value: "en"))
        case .fr:
            components.queryItems?.append(URLQueryItem(name: "metadata[language]", value: "fr"))
        case nil:
            break
        }
        var request = URLRequest(url: components.url!)

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(RecommendationsReponse.self, from: data)
    }
}
