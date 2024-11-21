//
//  LoginManager.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import Foundation
import KeychainSwift
import Model

final class LoginManager {
    static let shared: LoginManager = .init()

    private let loginActor: LoginActor = .init()

    private init() {}

    func getUser() async throws -> User? {
        guard let username: String = try? getLoginInfosFromKeyChain().username else {
            return nil
        }
        if isTokenExpired() {
            let username: String = try await refreshAccessToken().username
            return User(username: username)
        }
        return User(username: username)
    }

    func getAccessToken() throws -> String {
        try getLoginInfosFromKeyChain().access_token
    }

    func login(username: String, password: String) async throws -> User {
        let loginResponse: LoginResponse = try await loginActor.login(.credentials(username: username, password: password))
        try saveLoginInfosInKeyChain(loginResponse)
        return User(username: loginResponse.username)
    }

    func logout() {
        deleteLoginInfosFromKeyChain()
    }
}

// MARK: - Private functions -
private extension LoginManager {
    func saveLoginInfosInKeyChain(_ loginResponse: LoginResponse) throws {
        let loginJSON = try JSONEncoder().encode(loginResponse)
        KeychainSwift().set(String(Date().timeIntervalSince1970), forKey: Constants.Keychain.lastLoginDateKey)
        KeychainSwift().set(loginJSON, forKey: Constants.Keychain.loginResponseKey)
    }

    func deleteLoginInfosFromKeyChain() {
        KeychainSwift().delete(Constants.Keychain.lastLoginDateKey)
        KeychainSwift().delete(Constants.Keychain.loginResponseKey)
    }

    func getLoginInfosFromKeyChain() throws -> LoginResponse {
        guard let data: Data = KeychainSwift().getData(Constants.Keychain.loginResponseKey) else { throw AppError.loggedOut }
        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }

    func getlastLoginDateFromKeyChain() -> Date? {
        guard let data: Data = KeychainSwift().getData(Constants.Keychain.lastLoginDateKey),
              let timeInterval: TimeInterval = .init(String(decoding: data, as: UTF8.self)) else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }

    func isTokenExpired() -> Bool {
        guard let expiresIn = try? getLoginInfosFromKeyChain().expires_in,
              let lastLoginDate: Date = getlastLoginDateFromKeyChain() else {
            return true
        }
        let expirationDate = lastLoginDate.addingTimeInterval(TimeInterval(expiresIn))
        return Date() >= expirationDate
    }

    func refreshAccessToken() async throws -> LoginResponse {
        do {
            let refreshToken: String = try getLoginInfosFromKeyChain().refresh_token
            let loginResponse: LoginResponse = try await loginActor.login(.refreshToken(refreshToken: refreshToken))
            try saveLoginInfosInKeyChain(loginResponse)
            return loginResponse
        } catch {
            deleteLoginInfosFromKeyChain()
            throw error
        }
    }
}

// MARK: - Login Actor -
private extension LoginManager {
    final actor LoginActor {
        enum Kind {
            case credentials(username: String, password: String)
            case refreshToken(refreshToken: String)

            var requestBody: String {
                switch self {
                case .credentials(let username, let password):
                    "grant_type=password&client_id=\(Secrets.client_id)&username=\(username)&password=\(password)"
                case .refreshToken(let refreshToken):
                    "grant_type=refresh_token&client_id=\(Secrets.client_id)&refresh_token=\(refreshToken)"
                }
            }
        }
        func login(_ kind: Kind) async throws -> LoginResponse {
            guard let url = URL(string: Constants.URL.API.login) else { throw AppError.invalidURL }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            request.httpBody = kind.requestBody.data(using: .utf8)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == Constants.APIConstants.HttpResponseCode.success else {
                guard let loginError = try? JSONDecoder().decode(LoginErrorResponse.self, from: data) else {
                    throw AppError.loggedOut
                }
                throw loginError.toAppError()
            }
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        }
    }
}
