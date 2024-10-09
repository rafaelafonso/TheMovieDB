//
//  Genre.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 8/10/24.
//

import Foundation

struct Genres: Codable, Equatable {
    var genres: [Genre]
}

struct Genre: Codable, Identifiable, Hashable {
    var id: Int
    var name: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
