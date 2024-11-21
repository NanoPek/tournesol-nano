//
//  Error+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import Foundation

extension Error {
    var toAppError: AppError {
        self as? AppError ?? .appUnknown(self)
    }
}
