//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import Foundation

public enum MovieEndpoint: String {
    case fetchPopularMovies = "/movie/popular"
    case fetchMovie = "/movie"
}

class NetworkManager {
    static let shared = NetworkManager()
    let baseURLString: String = "https://api.themoviedb.org/3"

    func getRequest(_ endpoint: MovieEndpoint, id: Int? = nil, completion: @escaping (Result<Data, Error>) -> Void) {

        var urlString: String = baseURLString.appending(endpoint.rawValue)
        if let id = id {
            urlString.append("/\(id)")
        }
        if let apiKey = Environment.apiKey {
            urlString.append("?api_key=\(apiKey)")
        }

        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else { return }

            if let error = error {
                print(">Error: \(error)")
                completion(.failure(error))
                return
            }

            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                print(">Bad server response")
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print(">Completion success!")
            completion(.success(data))
        }
        task.resume()
    }
}
