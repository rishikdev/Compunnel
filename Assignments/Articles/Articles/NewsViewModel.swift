//
//  NewsViewModel.swift
//  Articles
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class NewsViewModel {
    var status: String = ""
    var articles: [Article] = []
    
    func getStatus(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.fetchStatus(from: Constants.urls.newsFeed.rawValue) { [weak self] result in
            switch result {
            case .success(let status):
                self?.status = status
                completion()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getArticles(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.fetchArticles(from: Constants.urls.newsFeed.rawValue) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                completion()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getArticle(at index: Int) -> Article {
        articles[index]
    }
}
