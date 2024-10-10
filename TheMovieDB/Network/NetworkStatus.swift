//
//  NetworkStatus.swift
//  TheMovieDB
//
//  Created by Rafael Afonso on 9/10/24.
//

import SwiftUI
import Network

class NetworkStatus: ObservableObject {
    let networkStatus = NWPathMonitor()
    let workerQueue = DispatchQueue(label: "Status")
    @Published var isConnected = false

    init() {
        networkStatus.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkStatus.start(queue: workerQueue)
    }
}
