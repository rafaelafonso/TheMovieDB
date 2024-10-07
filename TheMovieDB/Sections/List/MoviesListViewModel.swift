//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import SwiftUI

class MoviesListViewModel: ObservableObject {
    @Published var movies: Movies? = nil

    init() {
        fetchMovies()
    }
    
    func fetchMovies() {
        MovieService().fetchMovies { result in
            switch result {
            case .success(let movies):
                self.movies = movies                
            case .failure(_):
                print("> error")
            }
        }
    }

    func fetchMovieDetails(for movie: Movie) {
        MovieService().fetchMovieDetails(id: movie.id) { result in
            switch result {
            case .success(let movie):
                print("> movie details: \(movie)")
            case .failure(_):
                print("> error")
            }
        }
    }
}
