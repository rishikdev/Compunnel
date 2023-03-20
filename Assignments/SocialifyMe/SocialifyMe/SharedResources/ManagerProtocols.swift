//
//  ManagerProtocols.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import FirebaseAuth
import UIKit

protocol FirebaseAuthenticationService {
    func createAccount(email: String, password: String, completion: @escaping (String, Bool, User?) -> Void)
    func determineProvider(for email: String, completion: @escaping (String) -> Void)
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool, UserModel?) -> Void)
    func signInWithGoogle(withPresenting viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void)
    func signInWithFacebook(viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void)
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void)
}

protocol FirebaseStorageService {
    func uploadProfilePhotoToFirebaseStorage(uid: String, from urlPath: URL, completion: @escaping (String, String?, Bool) -> Void)
    func downloadProfilePhotoFromFirebaseStorage(uid: String, completion: @escaping (URL?, Bool) -> Void)
    func uploadPostToFirebaseStorage(user: LocalUser, from urlPath: URL, postDescription: String?, completion: @escaping (String, Bool) -> Void)
}

protocol FirebaseRealtimeDatabaseService {
    func createUserProfileInFirebaseDatabase(uid: String, userDictionary: [String: Any], completion: @escaping (String, Bool) -> Void)
    func updateUserProfileInFirebaseDatabase(uid: String, userDictionary: [String: Any], completion: @escaping (String, Bool) -> Void)
    func fetchUserProfileFromFirebaseDatabase(uid: String, completion: @escaping ([String: Any]?) -> Void)
    func uploadPostMetadataToFirebaseDatabase(uid: String, postMetadata: [String: Any], userInfo: [String: String], completion: @escaping (String?, Bool) -> Void)
    func fetchPostsMetadataFromFirebaseDatabase(completion: @escaping (Result<[PostModel], Error>) -> Void)
    func fetchPostsMetadataFromFirebaseDatabaseFor(uid: String, completion: @escaping (Result<[PostModel], Error>) -> Void)
    func updateUserInfoInFirebaseDatabase(uid: String, userName: String?, profilePhotoFirebaseStorageURL: String?)
}
