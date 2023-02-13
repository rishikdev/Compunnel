//
//  NewsViewModel.swift
//  Articles
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class NewsViewModel {
    var articles: [Article] = []
    var news: NewsModel?
    
    func getStatus(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.fetchStatus(from: Constants.urls.newsFeed.rawValue) { [weak self] (result: Result<NewsModel, Error>) in
            switch result {
            case .success(let model):
                self?.news = model
                if ((self?.isStatusOk()) != nil) {
                    self?.articles = model.articles
                    completion()
                } else {
                    completion()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isStatusOk() -> Bool {
         self.news?.status?.lowercased() == Constants.status.ok.rawValue
    }
    
    func formatDate(dateReceived: String) -> String {
        let dateFormatterReceived = DateFormatter()
        let dateFormatterOut = DateFormatter()
        
        dateFormatterReceived.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatterOut.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatterReceived.date(from: dateReceived) {
            return dateFormatterOut.string(from: date)
        } else {
            return "No Date"
        }
    }
    
    func getArticle(at index: Int) -> Article {
        articles[index]
    }
}
