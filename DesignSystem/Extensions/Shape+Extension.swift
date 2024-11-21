//
//  Shape+Extension.swift
//  DesignSystem
//
//  Created by Jérémie Carrez on 06/08/2024.
//

import SwiftUI

public extension Shape {
    func fill(_ color: DesignSystem.Color) -> some View {
        self
            .fill(color.color)
    }
}
