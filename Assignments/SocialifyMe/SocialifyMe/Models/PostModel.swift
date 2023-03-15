//
//  PostModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 13/03/23.
//

import Foundation

struct PostModel: Codable {
    var userProfilePhotoFirebaseStorageURL: String?
    var userName: String?
    var postPhotoStorageURL: String?
    var postTimeCreated: String?
    var postDescription: String?
}
