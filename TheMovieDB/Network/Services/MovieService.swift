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

    func fetchMovies(completion: @escaping (Result<Movies, Error>) -> Void) {

        NetworkManager.shared.getRequest(.fetchPopularMovies) { result in
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

//        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=")!
//
//        NetworkManager.shared.getRequest(url) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    do {
//                        let movies = try JSONDecoder().decode(Movies.self, from: data)
//                        completion(.success(movies))
//                    } catch {
//                        completion(.failure(MovieError(message: error.localizedDescription)))
//                    }
//                case .failure(let error):                    
//                    completion(.failure(MovieError(message: error.localizedDescription)))
//                }
//            }
//        }
    }

    func fetchMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {

        NetworkManager.shared.getRequest(.fetchMovie, id: id) { result in
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
//        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=")!
//        print("-->\(url)")
//
//        NetworkManager.shared.getRequest(url) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    do {
//                        let movie = try JSONDecoder().decode(Movie.self, from: data)
//                        completion(.success(movie))
//                    } catch {
//                        completion(.failure(MovieError(message: error.localizedDescription)))
//                    }
//                case .failure(let error):
//                    completion(.failure(MovieError(message: error.localizedDescription)))
//                }
//            }
//        }
    }
}
