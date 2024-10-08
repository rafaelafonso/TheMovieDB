//
//  MoviesListView.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import SwiftUI
import SwiftData

struct MoviesListView: View {

    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel: MoviesViewModel = MoviesViewModel()
    @State private var showDetailsView: Bool = false
    @State private var selectedMovie: Movie?

    let columns = [GridItem(.adaptive(minimum: 200))]

    var body: some View {
        NavigationStack {
            VStack {
                if let movies = viewModel.movies {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(Array(movies.results.enumerated()), id: \.offset) { index, movie in
                                MovieCardView(movie: movie)
                                    .onTapGesture {
                                        self.selectedMovie = movie
                                        self.showDetailsView = true
                                    }
                                    .onDisappear {
                                        if index == Int(movies.results.count - 5) {
                                            Task {
                                                viewModel.page += 1
                                                await viewModel.fetchMovies()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle(Text("Popular Movies"))
            .navigationDestination(isPresented: $showDetailsView) {
                if let movie = selectedMovie {
                    MovieDetailView(viewModel: viewModel, movie: movie)                        
                }
            }
        }
    }
}
