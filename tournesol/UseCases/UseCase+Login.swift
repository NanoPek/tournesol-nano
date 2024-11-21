//
//  UseCase+Login.swift
//  tournesol
//
//  Created by Jérémie Carrez on 08/04/2024.
//

import Foundation

extension UseCase {
    static func getUser() async throws -> User? {
        try await LoginManager.shared.getUser()
    }

    static func login(username: String, password: String) async throws -> User {
        try await LoginManager.shared.login(username: username, password: password)
    }

    static func logout() {
        LoginManager.shared.logout()
    }
}
