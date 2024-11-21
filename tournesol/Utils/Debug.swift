//
//  Debug.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

import Foundation

enum Debug {
    static func debugData(_ data: Data, title: String) {
        let str = String(decoding: data, as: UTF8.self)
        print("📈", title, str)
    }
}
