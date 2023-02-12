//
//  NewsModel.swift
//  Articles
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

struct NewsModel: Codable {
    var status: String?
    var articles: [Article]
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
