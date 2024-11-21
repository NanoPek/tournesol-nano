//
//  AppError.swift
//  tournesol
//
//  Created by Jérémie Carrez on 26/04/2024.
//

import Foundation
import Model

enum AppError: Error, Identifiable {
    // Login
    case loggedOut
    case failedToRefreshToken
    case invalidCredentials
    case loginError(LoginErrorResponse)

    // Rate later
    case alreadyInList

    // Other
    case invalidURL
    case appUnknown(Error?)

    var localizedDescription: LocalizedStringResource {
        switch self {
        case .loggedOut:
            "You're not logged in."
        case .failedToRefreshToken:
            "You're disconnected."
        case .invalidCredentials:
            "Invalid credentials given."
        case .loginError(let error):
            .init(stringLiteral: error.error_description)
        case .alreadyInList:
            "The video is already in your rate later list."
        case .invalidURL:
            "Invalid URL."
        case .appUnknown(let error):
            if let error {
                .init(stringLiteral: error.localizedDescription)
            } else {
                "An unknown Error occured."
            }
        }
    }

    var guidance: LocalizedStringResource? {
        switch self {
        case .loggedOut, .loginError:
            "Try to log in again."
        case .invalidCredentials:
            "Check your credentials and retry."
        case .failedToRefreshToken:
            "It's been a long time! You need to log in again :-)"
        case .invalidURL:
            "Please retry."
        default:
            nil
        }
    }

    var id: String {
        switch self {
        case .loggedOut:
            "loggedOut"
        case .failedToRefreshToken:
            "failedToRefreshToken"
        case .invalidCredentials:
            "invalidCredentials"
        case .loginError(let error):
            error.error
        case .alreadyInList:
            "alreadyInList"
        case .invalidURL:
            "invalidURL"
        case .appUnknown(let error):
            error?.localizedDescription ?? "appUnknown"
        }
    }
}
