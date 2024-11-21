//
//  TournesolLanguage.swift
//  tournesol
//
//  Created by Jérémie Carrez on 18/06/2024.
//

import Foundation

@frozen
public enum TournesolLanguage: String, Hashable, CaseIterable {
    case en
    case fr
}

extension TournesolLanguage: Identifiable {
    public var id: String { self.rawValue }
}
