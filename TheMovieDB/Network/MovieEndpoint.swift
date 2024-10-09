//
//  MovieEndpoint.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 7/10/24.
//

import Foundation

public enum MovieEndpoint {
    case fetchPopularMovies
    case fetchMovie(id: Int)
    case fetchMovieCredits(id: Int)
    case fetchGenres

    func apiEndpoint() -> String {
        let apiEndpoint: String
        switch self {
        case .fetchPopularMovies: apiEndpoint = "/movie/popular"
        case .fetchMovie(id: let id): apiEndpoint = "/movie/\(id)"
        case .fetchMovieCredits(id: let id): apiEndpoint = "/movie/\(id)/credits"
        case .fetchGenres: apiEndpoint = "/genre/movie/list"
        }
        return apiEndpoint
    }
}
