//
//  UserEnvironment.swift
//  tournesol
//
//  Created by Jérémie Carrez on 08/04/2024.
//

import Foundation

@MainActor
final class UserEnvironment: ObservableObject {
    @Published private(set) var user: User?

    var isLogged: Bool { user != nil }

    func loginFromKeyChain() async throws {
        self.user = try await UseCase.getUser()
    }

    func login(username: String, password: String) async throws {
        self.user = try await UseCase.login(username: username, password: password)
    }

    func logout() {
        UseCase.logout()
        self.user = nil
    }
}
