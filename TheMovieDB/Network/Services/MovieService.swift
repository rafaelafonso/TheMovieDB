//
//  MovieService.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import Foundation

class MovieError: Error {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}

struct MovieService {

    ///
    /// fetchMovies
    /// - Fetch popular movies.
    ///
    func fetchMovies(page: Int, completion: @escaping (Result<Movies, Error>) -> Void) {

        NetworkManager.shared.getRequest(.fetchPopularMovies, params: ["page": page]) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let movies = try JSONDecoder().decode(Movies.self, from: data)
                        completion(.success(movies))
                    } catch {
                        completion(.failure(MovieError(message: error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.failure(MovieError(message: error.localizedDescription)))
                }
            }
        }
    }

    ///
    /// fetchMovieDetails
    /// - Get movie details for a given movie ID.
    ///
    func fetchMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {

        NetworkManager.shared.getRequest(.fetchMovie(id: id)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let movie = try JSONDecoder().decode(Movie.self, from: data)
                        completion(.success(movie))
                    } catch {
                        completion(.failure(MovieError(message: error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.failure(MovieError(message: error.localizedDescription)))
                }
            }
        }
    }

    ///
    /// fetchMovieCredits
    /// - Get movie credits for a given movie ID.
    ///
    func fetchMovieCredits(id: Int, completion: @escaping (Result<MovieCredits, Error>) -> Void) {

        NetworkManager.shared.getRequest(.fetchMovieCredits(id: id)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let movieCredits = try JSONDecoder().decode(MovieCredits.self, from: data)
                        completion(.success(movieCredits))
                    } catch {
                        completion(.failure(MovieError(message: error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.failure(MovieError(message: error.localizedDescription)))
                }
            }
        }
    }
}
