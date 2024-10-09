//
//  Movie.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import SwiftUI
import SwiftData

struct Movies: Codable, Equatable {
    var results: [Movie]
}

struct Cast: Codable, Hashable {
    let name: String
}

struct Crew: Codable, Hashable {
    let name: String
    let job: String
}

struct MovieCredits: Codable, Hashable {
    var id: Int
    var cast: [Cast]
    var crew: [Crew]
}

struct Movie: Codable, Identifiable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case id, title, poster = "poster_path", releaseDate = "release_date", overview, genres = "genre_ids", director, cast, rating = "vote_average", votes = "vote_count"
    }

    var id: Int
    var title: String
    var poster: URL?
    var releaseDate: String
    var overview: String
    var genres: [Int]

    var director: String?
    var cast: [Cast]?
    var rating: Float?
    var votes: Int?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.overview = try container.decode(String.self, forKey: .overview)

        let poster = try container.decodeIfPresent(String.self, forKey: .poster) ?? "" //to improve this with placeholder when no poster
        self.poster = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
        self.genres = try container.decode([Int].self, forKey: .genres)

        // details
        self.director = try container.decodeIfPresent(String.self, forKey: .director)
        self.cast = try container.decodeIfPresent([Cast].self, forKey: .cast)
        self.rating = try container.decodeIfPresent(Float.self, forKey: .rating)
        self.votes = try container.decodeIfPresent(Int.self, forKey: .votes)
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
