//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import SwiftUI

class MoviesViewModel: ObservableObject {
    @Published var movies: Movies? = nil
    @Published var movieCredits: MovieCredits? = nil
    @Published var director: String? = nil
    @Published var page: Int = 1

    init() {
        Task {
            await self.fetchMovies()
        }
    }
    
    func fetchMovies() async {
        print(">VM: fetching movies")
        MovieService().fetchMovies(page: page) { result in
            switch result {
            case .success(let movies):
                if self.movies == nil {
                    self.movies = movies
                } else {
                    self.movies?.results.append(contentsOf: movies.results)
                }
            case .failure(_):
                print("> error")
            }
        }
    }

    func fetchMovieDetails(for movie: Movie) async {
        print(">VM: fetching movie details")
        MovieService().fetchMovieDetails(id: movie.id) { result in
            switch result {
            case .success(let movie):
                print("> movie details: \(movie)")
            case .failure(_):
                print("> error")
            }
        }
    }

    func fetchMovieCredits(for movie: Movie) async {
        print(">VM: fetching movie credits")
        MovieService().fetchMovieCredits(id: movie.id) { result in
            switch result {
            case .success(let movieCredits):
                self.movieCredits = movieCredits
                self.director = self.fetchDirector(from: movieCredits.crew)
            case .failure(_):
                print("> error")
            }
        }
    }
}

private extension MoviesViewModel {
    func fetchDirector(from crew: [Crew]) -> String? {
        for crewMember in crew {
            if crewMember.job == "Director" {
                return crewMember.name
            }
        }
        return nil
    }
}
