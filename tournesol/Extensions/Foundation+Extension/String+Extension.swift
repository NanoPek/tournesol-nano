//
//  String+Extension.swift
//  tournesol
//
//  Created by Jérémie Carrez on 04/08/2024.
//

import Foundation

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
