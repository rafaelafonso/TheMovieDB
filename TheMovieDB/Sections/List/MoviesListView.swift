//
//  MoviesListView.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import SwiftUI

struct MoviesListView: View {

    @StateObject var viewModel: MoviesListViewModel = MoviesListViewModel()
    let columns = [GridItem(.adaptive(minimum: 200))]

    var body: some View {

        VStack {
            if let movies = viewModel.movies {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(movies.results, id: \.self) { movie in
                            MovieCard(movie: movie)
                                .onTapGesture {
                                    viewModel.fetchMovieDetails(for: movie)
                                }
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.movies) { oldValue, newValue in
            print(">MOVIES: \(newValue)")
        }
    }
}

struct MovieCard: View {
    var movie: Movie

    var body: some View {

        HStack(alignment: .top, spacing: 4) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: movie.poster) { image in
                    image.image?
                        .resizable()
                        .frame(width: 90, height: 120)
                        .scaledToFit()
                        .cornerRadius(8)
                }
                Text("Released on: \n\(movie.releaseDate)")
                    .font(.caption)
            }

            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(movie.overview)
                    .font(.footnote)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor)
                .stroke(Color.primary, lineWidth: 1.0)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MovieCard(movie: Movie(id: 533535, title: "Deadpool & Wolverine", poster: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", releaseDate: "2024-07-24", overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine."))
}
