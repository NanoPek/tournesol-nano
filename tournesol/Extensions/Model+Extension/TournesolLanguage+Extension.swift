//
//  TournesolLanguage+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import Foundation
import Model

extension TournesolLanguage {
    var description: LocalizedStringResource {
        switch self {
        case .en:
            "English"
        case .fr:
            "French"
        }
    }
}
