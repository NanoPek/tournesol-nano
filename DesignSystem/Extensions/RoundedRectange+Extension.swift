//
//  RoundedRectange+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 14/11/2024.
//

import SwiftUI

public extension RoundedRectangle {
    init(cornerRadius: DesignSystem.CornerRadius) {
        self.init(cornerRadius: cornerRadius.rawValue)
    }
}
