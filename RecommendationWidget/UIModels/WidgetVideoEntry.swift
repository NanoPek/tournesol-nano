//
//  WidgetVideoEntry.swift
//  RecommendationWidgetExtension
//
//  Created by Jérémie Carrez on 23/08/2024.
//

import UIKit
import WidgetKit

struct WidgetVideoEntry: TimelineEntry {
    let date: Date
    let video: WidgetVideo?
    let thumbnail: UIImage?
}
