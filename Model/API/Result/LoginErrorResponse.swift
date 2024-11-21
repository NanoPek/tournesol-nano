//
//  LoginErrorResponse.swift
//  tournesol
//
//  Created by Jérémie Carrez on 14/08/2024.
//

import Foundation

public struct LoginErrorResponse: APIResult {
    public let error: String
    public let error_description: String
}
