//
//  VideoModel.swift
//  Videos
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

struct VideoModel: Codable {
    var transcodings: [Transcodings]
    var title: String?
}

struct Transcodings: Codable {
    var transcodingsID: String?
    var height: Int?
    var width: Int?
    
    enum CodingKeys: String, CodingKey {
        case transcodingsID = "id"
        case height, width
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transcodingsID = try container.decodeIfPresent(String.self, forKey: .transcodingsID)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.width = try container.decodeIfPresent(Int.self, forKey: .width)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.transcodingsID, forKey: .transcodingsID)
        try container.encodeIfPresent(self.height, forKey: .height)
        try container.encodeIfPresent(self.width, forKey: .width)
    }
}
