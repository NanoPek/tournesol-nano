//
//  Constants.swift
//  tournesol
//
//  Created by Jérémie Carrez on 08/04/2024.
//

import Foundation

@frozen
public enum Constants {
    public enum URL {
        public enum API {
            static private let baseUrl: String = "https://api.tournesol.app"
            public static let login: String = "\(baseUrl)/o/token/"

            public static let recommendations: String = "\(baseUrl)/polls/videos/recommendations"
            public static func personalRecommendations(_ username: String) -> String { "\(baseUrl)/users/\(username)/recommendations/videos"
            }

            public static let toCompare: String = "\(baseUrl)/users/me/suggestions/videos/tocompare/"
            public static let myComparisons: String = "\(baseUrl)/users/me/comparisons/videos"

            public static let rateLater: String = "\(baseUrl)/users/me/rate_later/videos/"
            public static func deleteRateLater(uid: String) -> String {
                rateLater + "yt:\(uid)/"
            }
        }
        public enum Tournesol {
            static private let baseUrl: String = "https://tournesol.app"
            public static let signUp: String = "\(baseUrl)/signup"
            public static let deleteAccount: String = "\(baseUrl)/settings/account"

            public static func entity(uid: String) -> String {
                "\(baseUrl)/entities/yt:\(uid)"
            }
            public static func comparison(uidA: String, uidB: String?) -> String {
                if let uidB {
                    "\(baseUrl)/comparison?uidA=yt:\(uidA)&uidB=yt:\(uidB)"
                } else {
                    "\(baseUrl)/comparison?uidA=yt:\(uidA)"
                }
            }
        }
        public enum Youtube {
            public static func ytPreview(uid: String) -> String { "https://i.ytimg.com/vi/\(uid)/mqdefault.jpg" }
            public static func ytlink(uid: String) -> String { "https://youtube.com/watch?v=\(uid)" }
        }
    }

    public enum APIConstants {
        public enum Comparison {
            public static let score_min: Int = -10
            public static let score_max: Int = 10
            public static let weight: Int = 1
        }

        public enum HttpResponseCode {
            public static let success: Int = 200
            public static let conflict: Int = 409
            public static let errorCodesRange: ClosedRange<Int> = 400...599
        }
    }

    public enum Keychain {
        public static let loginResponseKey: String = "loginResponse"
        public static let lastLoginDateKey: String = "lastLoginDate"
    }
}
