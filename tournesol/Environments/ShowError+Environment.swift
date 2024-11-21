//
//  ShowError+Environment.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import SwiftUI

struct ShowErrorKey: EnvironmentKey {
    static var defaultValue: (Error) -> Void = { _ in }
}

extension EnvironmentValues {
    var showError: (Error) -> Void {
        get { self[ShowErrorKey.self] }
        set { self[ShowErrorKey.self] = newValue }
    }
}
