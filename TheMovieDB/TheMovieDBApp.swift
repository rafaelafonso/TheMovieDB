//
//  TheMovieDBApp.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import SwiftUI
import SwiftData

@main
struct TheMovieDBApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteMovie.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MoviesListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
