//
//  SignedInHomeViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 10/03/23.
//

import Foundation

/// `ViewModel` class for ``SignedInHomeViewController``.
///
/// - Handles functionalities related to **uploading posts**.
///
/// - Functions:
///     - ``fetchPostsMetadata(completion:)``
///
class SignedInHomeViewModel {
    
    // MARK: - Fetch Posts Metadata
    /// Fetches post metadata from **Firebase Database**.
    ///
    /// - Calls ``FirebaseManager/fetchPostsMetadata(completion:)``.
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains a failure message.
    ///     2. `[PostModel]`: If the fetch was successful, this argument contains an array of ``PostModel``. Otherwise, it is nil.
    ///     2. `Bool`: Indicating whether the fetch was successful or not.
    ///
    /// - Parameters:
    ///   - completion: An escaping closure with three arguments.
    ///
    func fetchPostsMetadata(completion: @escaping (String, [PostModel]?, Bool) -> Void) {
        FirebaseManager.shared.fetchPostsMetadataFromFirebaseDatabase { result in
            switch(result) {
            case .failure(_):
                completion(Constants.Alerts.Messages.unsuccessfulPostFetch, nil, false)
                
            case .success(let postModelArray):
                completion(Constants.Alerts.Messages.successfulPostFetch, postModelArray, true)
            }
        }
    }
}
