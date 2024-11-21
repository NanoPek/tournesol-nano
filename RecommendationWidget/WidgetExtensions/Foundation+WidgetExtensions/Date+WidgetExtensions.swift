//
//  Date+WidgetExtensions.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 23/08/2024.
//

import Foundation

extension Date {
    static let tomorrowMidnight: Date =  Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)

    static let yesterday: Date = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    static let aWeekAgo: Date = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
    static let aMonthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
}
