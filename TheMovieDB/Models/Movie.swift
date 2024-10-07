//
//  Movie.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import Foundation

struct Movies: Codable, Equatable {
    let results: [Movie]
}

struct Movie: Codable, Hashable, Identifiable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case id, title, poster = "poster_path", releaseDate = "release_date", overview
    }

    let id: Int
    let title: String
    let poster: URL?
    let releaseDate: String
    let overview: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.overview = try container.decode(String.self, forKey: .overview)

        let poster = try container.decodeIfPresent(String.self, forKey: .poster) ?? "" //rafa: mejorar esto (con un placeholder si no hay poster)
        self.poster = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
    }

    init(id: Int, title: String, poster: String, releaseDate: String, overview: String) {

        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
        self.id = id
        self.title = title
        self.poster = posterURL
        self.releaseDate = releaseDate
        self.overview = overview
    }
}
