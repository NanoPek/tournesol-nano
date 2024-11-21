//
//  LoginResponse.swift
//  tournesol
//
//  Created by Jérémie Carrez on 09/04/2024.
//

import Foundation

public struct LoginResponse: APIResult {
    public let access_token: String
    public let expires_in: Int
    let token_type: String
    let scope: String
    public let refresh_token: String
    public let username: String
}
