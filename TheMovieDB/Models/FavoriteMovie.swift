//
//  FavoriteMovie.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 7/10/24.
//

import Foundation
import SwiftData

@Model
class FavoriteMovie {
    var id: Int = 0
    var title: String = ""
    var poster: URL? = nil
    var releaseDate: String = ""
    var overview: String = ""
    var director: String? = nil
    var cast: [Cast]? = nil
    var rating: Float? = nil
    var votes: Int? = nil

    init(id: Int, title: String, poster: URL?, releaseDate: String, overview: String, director: String?, cast: [Cast]?, rating: Float?, votes: Int?) {
        self.id = id
        self.title = title
        self.poster = poster
        self.releaseDate = releaseDate
        self.overview = overview
        self.director = director
        self.cast = cast
        self.rating = rating
        self.votes = votes
    }
}
