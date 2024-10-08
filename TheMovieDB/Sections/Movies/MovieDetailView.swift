//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 7/10/24.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {

    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: MoviesViewModel
    @Query var favorites: [FavoriteMovie]
    var movie: Movie
    @State private var isFavorite: Bool = false

    var body: some View {

        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 4) {
                    VStack(alignment: .leading) {
                        infoSection(title: "Director", content: viewModel.director ?? "")
                        infoSection(title: "Released on", content: movie.releaseDate)
                        infoSection(title: "Rating", content: "\(movie.rating ?? 0.0)")
                        infoSection(title: "Votes", content: "\(movie.votes ?? 0)")
                    }

                    Spacer()
                    AsyncImage(url: movie.poster) { image in
                        image.image?
                            .resizable()
                            .frame(width: 180, height: 240)
                            .scaledToFit()
                            .cornerRadius(8)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    infoSection(title: "Synopsis", content: movie.overview)

                    if let cast = viewModel.movieCredits?.cast, cast.count > 0 {
                        VStack(alignment: .leading) {
                            Text("Cast")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            ForEach(cast, id: \.self) { cast in
                                Text(cast.name)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .navigationTitle(movie.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.handleFavorite()
                } label: {
                    Image(systemName: self.isFavorite ? "heart.fill" : "heart")
                        .font(.body)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMovieDetails(for: movie)
                await viewModel.fetchMovieCredits(for: movie)
            }
            self.isFavorite = favorites.contains(where: { $0.id == movie.id })
        }
        .onDisappear {
            Task {
                do {
                    try modelContext.save()
                } catch let error {
                    print(">error saving modelContext: \(error.localizedDescription)")
                }
            }
        }
    }
}

private extension MovieDetailView {

    func handleFavorite() {

        self.isFavorite.toggle()

        if isFavorite {
            let favoriteMovie = FavoriteMovie(id: movie.id, title: movie.title, poster: movie.poster, releaseDate: movie.releaseDate, overview: movie.overview, director: movie.director, cast: movie.cast, rating: movie.rating, votes: movie.votes)
            modelContext.insert(favoriteMovie)
        } else {
            if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
                modelContext.delete(favorites[index])
            }
        }
    }

    func infoSection(title: String, content: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            Text(content)
                .font(.subheadline)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
//    MovieDetailView(viewModel: MoviesViewModel(), movie: Movie(id: 533535, title: "Deadpool & Wolverine", poster: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", releaseDate: "2024-07-24", overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.", cast: [Cast(name: "Pedrito"), Cast(name: "Miguelito"), Cast(name: "Juanita")]))

}
