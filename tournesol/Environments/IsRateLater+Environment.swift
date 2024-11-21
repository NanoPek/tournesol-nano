//
//  IsRateLater+Environment.swift
//  tournesol
//
//  Created by Jérémie Carrez on 18/06/2024.
//

import SwiftUI

struct IsRateLaterKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var isRateLater: Bool {
        get { self[IsRateLaterKey.self] }
        set { self[IsRateLaterKey.self] = newValue }
    }
}
