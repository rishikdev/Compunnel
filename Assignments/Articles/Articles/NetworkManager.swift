//
//  NetworkManager.swift
//  Articles
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class NetworkManager {
    static let sharedInstance = NetworkManager()
    private init() {}
    
    func fetchStatus(from urlString: String, completion: @escaping (Result<String, Error>) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let receivedError = error {
                completion(.failure(receivedError))
            } else {
                guard let receivedData = data else { return }
                do {
                    let receivedModel = try JSONDecoder().decode(NewsModel.self, from: receivedData)
                    completion(.success(receivedModel.status ?? "NOT FOUND"))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchArticles(from urlString: String, completion: @escaping (Result<[Article], Error>) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let receivedError = error {
                completion(.failure(receivedError))
            } else {
                guard let receivedData = data else { return }
                do {
                    let receivedModel = try JSONDecoder().decode(NewsModel.self, from: receivedData)
                    completion(.success(receivedModel.articles))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
