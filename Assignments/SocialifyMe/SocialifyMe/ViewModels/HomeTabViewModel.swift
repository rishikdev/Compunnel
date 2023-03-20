//
//  SignedInHomeViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 10/03/23.
//

import Foundation

/// `ViewModel` class for ``HomeTabViewController``.
///
/// - Handles functionalities related to **uploading posts**.
///
/// - Properties:
///     - ``posts``
///
/// - Functions:
///     - ``fetchPostsMetadata(completion:)``
///
class HomeTabViewModel {
    
    var posts: [PostModel] = []
    
    // MARK: - Fetch Posts Metadata
    /// Fetches post metadata from **Firebase Database**.
    ///
    /// - Calls ``FirebaseManager/fetchPostsMetadata(completion:)``.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains a failure message.
    ///     2. `Bool`: Indicating whether the fetch was successful or not.
    ///
    /// - Parameters:
    ///   - completion: An escaping closure with two arguments.
    ///
    func fetchPostsMetadata(completion: @escaping (String, Bool) -> Void) {
        FirebaseRealtimeDatabaseManager.shared.fetchPostsMetadataFromFirebaseDatabase { result in
            switch(result) {
            case .failure(_):
                completion(Constants.Alerts.Messages.unsuccessfulPostFetch, false)
                
            case .success(let posts):
                self.posts = posts
                self.posts.sort { p1, p2 in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                    dateFormatter.timeZone = .gmt
                    let date1 = dateFormatter.date(from: p1.postTimeCreated!)
                    
                    return (date1 ?? Date()) > (dateFormatter.date(from: p2.postTimeCreated!) ?? Date())
                }
                completion(Constants.Alerts.Messages.successfulPostFetch, true)
            }
        }
    }
}
