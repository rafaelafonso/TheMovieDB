//
//  ApiEnvironment.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 6/10/24.
//

import Foundation

struct ApiEnvironment {
    static let apiKey: String? = {
        return ProcessInfo.processInfo.environment["API_KEY"]
    }()
}
