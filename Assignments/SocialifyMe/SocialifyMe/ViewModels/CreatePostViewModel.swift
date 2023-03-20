//
//  CreatePostViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 14/03/23.
//

import Foundation

/// `View Model` class for ``CreatePostViewController``
///
/// - Handles functionalities related to **uploading posts**.
///
/// - Functions:
///     - ``uploadPostToFirebaseStorage(user:from:description:completion:)``
///
class CreatePostViewModel {
    
    // MARK: - Upload Post To Firebase Storage
    /// Uploads user's posts to **Firebase Storage**.
    ///
    /// - Calls ``FirebaseManager/uploadPostToFirebaseStorage(uid:from:completion:)``.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains the reason why the upload failed.
    ///     2. `Bool`: Indicating whether the photo was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - urlPath: Local storage URL of photo to be posted.
    ///   - description: A description of the post.
    ///   - completion: An escaping closure with two arguments.
    ///
    func uploadPostToFirebaseStorage(user: LocalUser, from urlPath: URL, description: String?, completion: @escaping (String, Bool) -> Void) {
        FirebaseStorageManager.shared.uploadPostToFirebaseStorage(user: user, from: urlPath, postDescription: description) { postUploadMessage, isPostUploaded in completion(postUploadMessage, isPostUploaded) }
    }
}
