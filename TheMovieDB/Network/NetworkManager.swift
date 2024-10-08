//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 4/10/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURLString: String = "https://api.themoviedb.org/3"

    func getRequest(_ endpoint: MovieEndpoint, params: [String: CustomStringConvertible] = [:], completion: @escaping (Result<Data, Error>) -> Void) {

        let urlString: String = baseURLString.appending(endpoint.apiEndpoint())

        guard var url = URL(string: urlString) else { return }
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value.description) }
            if let apiKey = ApiEnvironment.apiKey {
                components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
            }
            if let composedUrl = components.url {
                url = composedUrl
            }
        }

        print(">url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard let data = data, let _ = String(data: data, encoding: .utf8) else { return }

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
