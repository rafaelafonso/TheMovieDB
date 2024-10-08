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

    @State private var searchText: String = ""

    var filteredMovies: [Movie] {
        if let movies = viewModel.movies {
            if searchText.isEmpty {
                return movies.results
            } else {
                return movies.results.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        } else {
            return []
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(filteredMovies.enumerated()), id: \.offset) { index, movie in
                            MovieCardView(movie: movie)
                                .onTapGesture {
                                    self.selectedMovie = movie
                                    self.showDetailsView = true
                                }
                        }
                        .searchable(text: $searchText, prompt: "Search movie")

                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    let offsetY = geometry.frame(in: .global).maxY
                                    let height = UIScreen.main.bounds.height
                                    if offsetY < height * 1.2 {
                                        Task {
                                            viewModel.page += 1
                                            await viewModel.fetchMovies()
                                        }
                                    }
                                }
                        }
                        .frame(height: 20)
                    }
                }
                .padding(.top)
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
