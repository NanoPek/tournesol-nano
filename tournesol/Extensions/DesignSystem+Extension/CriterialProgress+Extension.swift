//
//  CriterialProgress+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 06/08/2024.
//

import Foundation
import DesignSystem
import Model

extension CriterialProgress {
    init(criteria: Criteria, score: Double, detailsShown: Bool) {
        self.init(
            description: criteria.description,
            icon: criteria.icon,
            score: score,
            color: criteria.color,
            detailsShown: detailsShown
        )
    }
}
