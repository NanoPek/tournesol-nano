//
//  WidgetUseCase.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import Foundation

enum WidgetUseCase {
    static func getDailyRecommendation() async throws -> WidgetVideo? {

        async let daily = WidgetTournesolAPIManager.shared.getRecommendation(
            limit: Constants.limit,
            date_gte: .yesterday,
            language: nil
        )
        async let weekly = WidgetTournesolAPIManager.shared.getRecommendation(
            limit: Constants.limit,
            date_gte: .aWeekAgo,
            language: nil
        )
        async let monthly = WidgetTournesolAPIManager.shared.getRecommendation(
            limit: Constants.limit,
            date_gte: .aMonthAgo,
            language: nil
        )

        let (dailyVideo, weeklyVideo, monthlyVideo) = try await (daily.results.first, weekly.results.randomElement(), monthly.results.randomElement())

        return (dailyVideo ?? weeklyVideo ?? monthlyVideo)?.toWidgetVideo()
    }
}

private enum Constants {
    static let limit: Int = 20
}
