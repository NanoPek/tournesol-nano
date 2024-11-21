//
//  LoginErrorResponse+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 22/08/2024.
//

import Foundation
import Model

extension LoginErrorResponse {
    func toAppError() -> AppError {
        if self.error == Constants.invalidCredentialsId {
            .invalidCredentials
        } else {
            .loginError(self)
        }
    }
}

private extension Constants {
    static let invalidCredentialsId: String = "invalid_grant"
}
