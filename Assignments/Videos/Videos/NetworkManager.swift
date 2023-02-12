//
//  NetworkManager.swift
//  Videos
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class NetworkManager {
    static let sharedInstance = NetworkManager()
    private init() {}
    
    func fetchVideos(from urlString: String, completion: @escaping (Result<[VideoModel], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let receivedError = error {
                completion(.failure(receivedError))
            } else {
                guard let receivedData = data else { return }
                
                do {
                    let receivedModel = try JSONDecoder().decode([VideoModel].self, from: receivedData)
                    completion(.success(receivedModel))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
