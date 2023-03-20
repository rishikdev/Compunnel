//
//  FirebaseRealtimeDatabaseManager.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import FirebaseDatabase

/// `Singleton` class for managing `API` calls to `Firebase Realtime Database`.
///
/// - Properties:
///     - ``databaseRef``
///
/// - Functions:
///     - **Firebase Realtime Database Functions**
///     - ``createUserProfileInFirebaseDatabase(uid:userDictionary:completion:)``
///     - ``updateUserProfileInFirebaseDatabase(uid:userDictionary:completion:)``
///     - ``fetchUserProfileFromFirebaseDatabase(uid:completion:)``
///     - ``uploadPostMetadataToFirebaseDatabase(uid:postMetadata:userInfo:completion:)``
///     - ``updatePostMetadataInFirebaseDatabase(uidUser:primaryKeyPost:postMetadata:completion:)``
///     - ``fetchPostsMetadataFromFirebaseDatabase(completion:)``
///     - ``updateUserInfoInFirebaseDatabase(uid:userName:profilePhotoFirebaseStorageURL:)``
///
class FirebaseRealtimeDatabaseManager {
    var databaseRef: DatabaseReference!
    
    static let shared = FirebaseRealtimeDatabaseManager()
    
    private init() {
        self.databaseRef = Database.database().reference()
    }
        
    // MARK: - Create User Profile In Firebase Database
    /// Creates user's profile in **Firebase Realtime Database**.
    ///
    /// - Creates a `UserModel` object and converts it to a dictionary.
    /// - Calls FirebaseManager's `createUserProfileInFirebaseDatabase(uid, user)` function.
    /// - If the users sign up using **Email and Password**, their profile is created using the information obtained from the sign up page.
    /// - If the users sign up using **Google**, their profile is created using their`first name` and `last name` obtained from Google.
    /// - If the users sign up using **Facebook**, their profile is created using their`first name`, `middle name` and `last name` obtained from Facebook.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully created in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile creation failed.
    ///     2. `Bool`: Indicating whether the profile was created or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - user: A `dictionary` with user's informaition.
    ///   - completion: An escaping closure with two arguments.
    ///
    func createUserProfileInFirebaseDatabase(uid: String, userDictionary: [String: Any], completion: @escaping (String, Bool) -> Void) {
        let userProfileRef = self.databaseRef.child("data").child("users").child(uid)
        
        userProfileRef.setValue(userDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(Constants.Alerts.Messages.unsuccessfulProfileCreation, false)
            } else {
                let userName = (userDictionary["firstName"] as! String) + " " + ((userDictionary["lastName"] ?? "") as! String)
                self.updateUserInfoInFirebaseDatabase(uid: uid, userName: userName)
                completion(Constants.Alerts.Messages.successfulProfileCreation, true)
            }
        }
    }
    
    // MARK: - Update User Profile In Firebase Database
    /// Updates user's profile in **Firebase Realtime Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully updated in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile updation failed.
    ///     2. `Bool`: Indicating whether the profile was updated or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - user: A `dictionary` with user's informaition.
    ///   - completion: An escaping closure with two arguments.
    ///
    func updateUserProfileInFirebaseDatabase(uid: String, userDictionary: [String: Any], completion: @escaping (String, Bool) -> Void) {
        let userProfileRef = self.databaseRef.child("data").child("users/\(uid)/")
        
        userProfileRef.setValue(userDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(Constants.Alerts.Messages.unsuccessfulProfileCreation, false)
            } else {
                let userName = (userDictionary["firstName"] as! String) + " " + ((userDictionary["lastName"] ?? "") as! String)
                self.updateUserInfoInFirebaseDatabase(uid: uid, userName: userName)
                completion(Constants.Alerts.Messages.successfulProfileUpdation, true)
            }
        }
    }
    // TODO: Perform error handling
    // MARK: - Fetch User Profile From Firebase Database
    /// Fetches user's profile from Firebase **Realtime Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully updated in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile updation failed.
    ///     2. `Bool`: Indicating whether the profile was updated or not.
    ///
    /// - Parameters:
    ///   - uid: An object of type `UserModel`.
    ///   - completion: An escaping closure with one argument.
    ///
    func fetchUserProfileFromFirebaseDatabase(uid: String, completion: @escaping ([String: Any]?) -> Void) {
        self.databaseRef.child("data").child("users/\(uid)/").getData(completion:  { error, snapshot in
            if let error = error {
                print("ERROR FETCHING USER FROM FIREBASE \(error)")
                completion(nil)
            }
            
            if let user = snapshot?.value as? [String: Any] {
                completion(user)
            }
        })
    }
    
    // MARK: - Upload Post Metadata To Firebase Database
    /// Uploads user's post's metadata to **Firebase Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String?`: If the photo's `metadata` was successfully uploaded to **Firebase**, this argument contains the `primary key` of the created record. Otherwise, it contains `nil`.
    ///     2. `Bool`: Indicating whether the photo's `metadata` was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - postMetadata: The `metadata` of the photo to be posted.
    ///   - userInfo: Some relevant information about the user.
    ///   - completion: An escaping closure with two arguments.
    ///
    func uploadPostMetadataToFirebaseDatabase(uid: String, postMetadata: [String: Any], userInfo: [String: String], completion: @escaping (String?, Bool) -> Void) {
        let postUserInfoRef = self.databaseRef.child("data").child("posts").child(uid).child("userInfo")
        let postMetadataRef = self.databaseRef.child("data").child("posts").child(uid).childByAutoId()
        
        postUserInfoRef.setValue(userInfo)
        
        postMetadataRef.setValue(postMetadata) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Post could not be uploaded: \(error)")
                completion(nil, false)
            } else {
                print("Post saved successfully!")
                completion(postMetadataRef.key, true)
            }
        }
    }
    
    // MARK: - Update Post Metadata In Firebase Database
    /// Updates user's post's metadata in **Firebase Database**.
    ///
    /// - The parameter `completion` has one argument:
    ///     - `Bool`: Indicating whether the photo's `metadata` was updated or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in **Firebase**.
    ///   - primaryKeyPost: The `primary key` of the user's post.
    ///   - postMetadata: The `metadata` of the photo to be posted.
    ///   - completion: An escaping closure with one argument.
    ///
    func updatePostMetadataInFirebaseDatabase(uidUser: String, primaryKeyPost: String, postMetadata: [String: Any], completion: @escaping (Bool) -> Void) {
        let postMetadataRef = self.databaseRef.child("data/posts/\(uidUser)/\(primaryKeyPost)")
        
        postMetadataRef.setValue(postMetadata) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Post could not be uploaded: \(error)")
                completion(false)
            } else {
                print("Post updated successfully!")
                completion(true)
            }
        }
    }
    
    //MARK: - Fetch Posts From Firebase Database
    /// Fetches post metadata from **Firebase Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `Result`: If the fetch was successful, it contains an array of ``PostModel``. Otherwise, it contains error message.
    ///
    /// - Parameter completion: An escaping closure with one parameter.
    ///
    func fetchPostsMetadataFromFirebaseDatabase(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        let postRef = self.databaseRef.child("data/posts")
        postRef.getData { error, snapshot in
            if let error = error {
                print("ERROR FETCHING POSTS: \(error)")
                completion(.failure(error))
            }
            
            var postModelArray: [PostModel] = []
            
            if let postsMetadata = snapshot?.value as? [String: NSDictionary] {
                for posts in postsMetadata.values {
                    let userInfo = posts["userInfo"] as? NSDictionary
                    for post in posts.allValues {
                        if let postDictionary = post as? NSDictionary {
                            /// This `if` condition is used to differentiate `post` object from `userInfo` object.
                            /// `post` object does not have `timeCreated` and `postPhotoStorageURL` fields, therefore, they will be `nil`.
                            if(postDictionary["postTimeCreated"] != nil && postDictionary["postPhotoStorageURL"] != nil)
                            {
                                let postModel = PostModel(userProfilePhotoFirebaseStorageURL: userInfo?["userProfilePhotoFirebaseStorageURL"] as? String,
                                                          userName: userInfo?["userName"] as? String,
                                                          postPhotoStorageURL: postDictionary["postPhotoStorageURL"] as? String,
                                                          postTimeCreated: postDictionary["postTimeCreated"] as? String,
                                                          postDescription: postDictionary["postDescription"] as? String)
                                postModelArray.append(postModel)
                            }
                        }
                    }
                }
                completion(.success(postModelArray))
            }
        }
    }
    
    // MARK: - Fetch Posts From Firebase Database For
    /// Fetches post metadata from **Firebase Database** for the provided `uid`.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `Result`: If the fetch was successful, it contains an array of ``PostModel``. Otherwise, it contains error message.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in **Firebase**.
    ///   - completion: An escaping closure with one parameter.
    ///
    func fetchPostsMetadataFromFirebaseDatabaseFor(uid: String, completion: @escaping (Result<[PostModel], Error>) -> Void) {
        let postRef = self.databaseRef.child("data/posts/\(uid)")
        postRef.getData { error, snapshot in
            if let error = error {
                print("ERROR FETCHING POSTS: \(error)")
                print(error)
                completion(.failure(error))
            }
            
            var postModelArray: [PostModel] = []
            
            if let postsMetadata = snapshot?.value as? [String: NSDictionary] {
                let userInfo = postsMetadata["userInfo"]
                for post in postsMetadata.values {
                    if(post["postTimeCreated"] != nil && post["postPhotoStorageURL"] != nil) {
                        let postModel = PostModel(userProfilePhotoFirebaseStorageURL: userInfo?["userProfilePhotoFirebaseStorageURL"] as? String,
                                                  userName: userInfo?["userName"] as? String,
                                                  postPhotoStorageURL: post["postPhotoStorageURL"] as? String,
                                                  postTimeCreated: post["postTimeCreated"] as? String,
                                                  postDescription: post["postDescription"] as? String)
                        postModelArray.append(postModel)
                    }
                }
                completion(.success(postModelArray))
            }
        }
    }
    
    // MARK: - Update UserInfo In Firebase Database
    /// Updates `userInfo` in **Firebase Database**.
    ///
    /// - If the `userInfo` field is not present in **Firebase Database**, this function creates it.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in **Firebase**.
    ///   - userName: The name of the user.
    ///   - profilePhotoFirebaseStorageURL: The `URL` of the user's profile photo stored in **Firebase Storage**.
    ///
    func updateUserInfoInFirebaseDatabase(uid: String, userName: String? = nil, profilePhotoFirebaseStorageURL: String? = nil) {
        let userInfoPostRef = self.databaseRef.child("data").child("posts").child(uid).child("userInfo")
        
        if(userName == nil) {
            userInfoPostRef.child("userProfilePhotoFirebaseStorageURL").setValue(profilePhotoFirebaseStorageURL)
        }
        
        if(profilePhotoFirebaseStorageURL == nil) {
            userInfoPostRef.child("userName").setValue(userName)
        }
    }
}

