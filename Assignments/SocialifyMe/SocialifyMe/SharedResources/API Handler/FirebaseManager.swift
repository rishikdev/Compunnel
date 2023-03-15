//
//  FirebaseManager.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn
import FacebookLogin

/// `Singleton` class for managing `API` calls to `Firebase`.
///
/// - Properties:
///     - ``databaseRef``
///     - ``storageRef``
///     - ``facebookLoginManager``
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
///     - **Firebase Storage Functions**
///     - ``uploadProfilePhotoToFirebaseStorage(uid:from:completion:)``
///     - ``downloadProfilePhotoFromFirebaseStorage(uid:completion:)``
///     - ``uploadPostToFirebaseStorage(user:from:description:completion:)``
///     - **Firebase Authentication Functions**
///     - ``createAccount(email:password:completion:)``
///     - ``determineProvider(for:completion:)``
///     - ``signInWithEmailPassword(email:password:completion:)``
///     - ``signInWithGoogle(withPresenting:completion:)``
///     - ``signInWithFacebook(viewController:completion:)``
///     - ``signOut(completion:)``
///
class FirebaseManager {
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var facebookLoginManager: LoginManager!
    
    static let shared = FirebaseManager()
    
    private init() {
        self.databaseRef = Database.database().reference()
        self.storageRef = Storage.storage().reference()
        self.facebookLoginManager = LoginManager()
    }
    
    // MARK: - Firebase Realtime Database Functions
    
    // MARK: Create User Profile In Firebase Database
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
    
    // MARK: Update User Profile In Firebase Database
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
    // MARK: Fetch User Profile From Firebase Database
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
    
    // MARK: Upload Post Metadata To Firebase Database
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
    
    // MARK: Update Post Metadata In Firebase Database
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
    
    //MARK: Fetch Posts From Firebase Database
    /// Fetches post metadata from **Firebase Database**
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
    
    // MARK: Update UserInfo In Firebase Database
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
    
    // MARK: - Firebase Storage Functions
    
    //MARK: Upload Profile Photo To Firebase Storage
    /// Uploads user's profile photo to **Firebase Storage**.
    /// 
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains the reason why the upload failed.
    ///     2. `String`: If the upload was successful, this argument contains the download `URL` of the profile photo. Otherwise, it contains nil.
    ///     2. `Bool`: Indicating whether the profile photo was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - urlPath: Local storage URL of profile photo.
    ///   - completion: An escaping closure with two arguments.
    ///
    func uploadProfilePhotoToFirebaseStorage(uid: String, from urlPath: URL, completion: @escaping (String, String?, Bool) -> Void) {
        let profilePhotoRef = self.storageRef.child("data").child("users").child(uid).child(Constants.ProfilePhoto.name).child(Constants.ProfilePhoto.name + Constants.ProfilePhoto.extn)
        let profilePhotoMetadata = StorageMetadata()
        profilePhotoMetadata.contentType = "image/jpeg"
        
        let uploadTask = profilePhotoRef.putFile(from: urlPath, metadata: profilePhotoMetadata)
        
        uploadTask.observe(.success) { _ in
            uploadTask.removeAllObservers()
            
            profilePhotoRef.downloadURL { downloadURL, error in
                guard let downloadURL = downloadURL else {
                    completion(Constants.Alerts.Messages.successfulProfilePhotoUpload, nil, true)
                    return
                }
                self.updateUserInfoInFirebaseDatabase(uid: uid, profilePhotoFirebaseStorageURL: downloadURL.absoluteString)
                
                completion(Constants.Alerts.Messages.successfulProfilePhotoUpload, downloadURL.absoluteString, true)
            }
        }
        
        uploadTask.observe(.failure) { _ in
            uploadTask.removeAllObservers()
            completion(Constants.Alerts.Messages.unsuccessfulProfilePhotoUpload, nil, false)
        }
    }
    
    // MARK: Download Profile Photo From Firebase Storage
    /// Downloads user's profile photo from **Firebase Storage** to **local storage**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `URL?`: If the profile photo was downloaded successfully, this argument contains the path of the downloaded profile photo. Otherwise, it is nil.
    ///     2. `Bool`: Indicating whether the profile photo was downloaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - completion: An escaping closure with two arguments.
    ///
    func downloadProfilePhotoFromFirebaseStorage(uid: String, completion: @escaping (URL?, Bool) -> Void) {
        let profilePhotoRef = self.storageRef.child("data").child("users").child(uid).child("profilePhoto").child("profilePhoto.jpeg")
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localProfilePhoto = documentDirectory.appending(path: "profilePhoto.jpeg")
        
        profilePhotoRef.write(toFile: localProfilePhoto) { url, error in
            if let error = error {
                print("COULD NOT DOWNLOAD PROFILE PHOTO: \(error)")
                completion(nil, false)
            }
            
            if let profilePhotoURL = url {
                if let imageData = try? Data(contentsOf: profilePhotoURL) {
                    try? imageData.write(to: localProfilePhoto)
                }
                
                completion(url, true)
            }
        }
    }
    
    //MARK: Upload Post To Firebase Storage
    /// Uploads user's posts to **Firebase Storage**.
    ///
    /// - Calls ``FirebaseManager/uploadPostMetadataToFirebaseDatabase(uid:postMetadata:userInfo:completion:)`` to upload the `metadata` of the selected photo to **Firebase Realtime Database** to get the `primary key` associated with it.
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
    func uploadPostToFirebaseStorage(user: LocalUser, from urlPath: URL, postDescription: String?, completion: @escaping (String, Bool) -> Void) {
        let postMetadata = StorageMetadata()
        postMetadata.contentType = "image/jpeg"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm"
        
        var postMetadataDictionary: [String: Any] = ["contentType": "image/jpeg",
                                                     "postDescription": postDescription ?? "",
                                                     "postTimeCreated": dateFormatter.string(from: Date())]
        
        let userInfo: [String: String] = ["userName": user.firstName! + " " + (user.lastName ?? ""),
                                          "userProfilePhotoFirebaseStorageURL": user.profilePhotoFirebaseStorageURL ?? ""]
        
        self.uploadPostMetadataToFirebaseDatabase(uid: user.uid!, postMetadata: postMetadataDictionary, userInfo: userInfo) { [weak self] primaryKey, isPostMetadataUploaded in
            if let primaryKey = primaryKey,
               isPostMetadataUploaded {
                let postRef = self?.storageRef.child("data").child("posts").child(user.uid!).child(primaryKey)
                let uploadTask = postRef?.putFile(from: urlPath, metadata: postMetadata)
                
                uploadTask?.observe(.success) { _ in
                    uploadTask?.removeAllObservers()
                    
                    postRef?.downloadURL { [weak self] downloadURL, downloadError in
                        if let downloadURL = downloadURL?.absoluteString {
                            postMetadataDictionary["postPhotoStorageURL"] = downloadURL
                            self?.updatePostMetadataInFirebaseDatabase(uidUser: user.uid!, primaryKeyPost: primaryKey, postMetadata: postMetadataDictionary) { isPostMetadataUpdated in
                                if(isPostMetadataUpdated) {
                                    completion(Constants.Alerts.Messages.successfulPostUpload, true)
                                } else {
                                    completion(Constants.Alerts.Messages.successfulPostUpload, true)
                                }
                            }
                        } else {
                            completion(Constants.Alerts.Messages.successfulPostUpload, true)
                        }
                    }
                }
                
                uploadTask?.observe(.failure) { _ in
                    uploadTask?.removeAllObservers()
                    completion(Constants.Alerts.Messages.unsuccessfulPostUpload, false)
                }
            } else {
                completion(Constants.Alerts.Messages.unsuccessfulPostUpload, false)
            }
        }
    }
    
    // MARK: - Firebase Authentication Functions
    
    // MARK: Create Account
    /// Creates user's account on **Firebase**.
    ///
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the account creation was successful, this argument contains a success message. Otherwise, it contains the reason why the account creation failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `User?`: If the account creation was successful, this argument has an object of type User. Otherwise, it is nil.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - password: Password of the user.
    ///   - completion: An escaping closure with three arguments.
    ///
    func createAccount(email: String, password: String, completion: @escaping (String, Bool, User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as? AuthErrorCode {
                print("ERROR CREATING ACCOUNT: \(error.errorCode)\n \(error)")
                
                self?.determineProvider(for: email) { provider in
                    if(provider == Constants.Providers.noProvider) {
                        /// This indicates that the email address is not in use. Something else is wrong.
                        switch(error.code) {
                        case .invalidEmail:
                            print("EMAIL")
                        case .weakPassword:
                            print("PASSWORD")
                        default:
                            print(error)
                        }
                        completion(error.localizedDescription, false, nil)
                    } else {
                        /// This indicates that the email is already in use by another provider.
                        ///
                        /// The user previously signed up with email address and password.
                        if(provider == Constants.Providers.emailPassword) {
                            completion(Constants.Alerts.Messages.unsuccessfulSignUpUserAlreadyExists, false, nil)
                        } else {
                            /// The user previously signed up with a different provider.
                            completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil)
                        }
                    }
                }
            }
            
            if let user = authResult?.user {
                completion(Constants.Alerts.Messages.successfulSignUp, true, user)
            }
        }
    }
    
    // MARK: Determine Provider
    /// Determines the **Provider** for a given **Email Address**.
    ///
    /// - The parameter `completion` has one argument:
    ///     1. `String`: If an account exists with the given email address, this argument contains the `provider` associated with that account. Otherwise, it contains an empty `String` signifying that no `provider` exists.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - completion: An escaping closure with one argument.
    ///
    /// - Note: An empty `provider` can signify two things: either the email is not registered on `Firebase`, or some `error` occurred while fetching `providers`.
    ///
    func determineProvider(for email: String, completion: @escaping (String) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { result, error in
            if let result = result {
                completion(result[0])
                return
            } else {
                completion(Constants.Providers.noProvider)
            }
            
            if let error = error {
                print("ERROR FETCHING PROVIDER: \(error)")
                completion(Constants.Providers.noProvider)
                return
            }
        }
    }
    
    // MARK: Sign In With Email Password
    /// Signs users in using their **Email Address** and **Password**.
    ///
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `UserModel?`: If the authentication was successful, this argument has an object of type `UserModel`. Otherwise, it is nil.
    ///
    /// - Parameters:
    ///   - email: The email address of the user
    ///   - password: The password of the user
    ///   - completion: An escaping closure with three arguments
    ///
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool, UserModel?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
                            
            if let error = error as? AuthErrorCode {
                print("ERROR SIGNING In: \(error.errorCode)\n \(error)")
                
                strongSelf.determineProvider(for: email) { provider in
                    if(provider == Constants.Providers.noProvider || provider == Constants.Providers.emailPassword) {
                        /// This indicates that the email address is not in use. Something else is wrong.
                        completion(Constants.Alerts.Messages.unsuccessfulSignIn, false, nil)
                    } else {
                        /// This indicates that the email is already in use by another provider.
                        completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil)
                    }
                }
            }
            
            if let user = authResult?.user {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                self?.fetchUserProfileFromFirebaseDatabase(uid: user.uid) { userProfile in
                    let userModel = UserModel(uid: user.uid,
                                              providerName: userProfile?["providerName"] as? String,
                                              firstName: userProfile?["firstName"] as? String,
                                              middleName: userProfile?["middleName"] as? String,
                                              lastName: userProfile?["lastName"] as? String,
                                              age: userProfile?["age"] as? Int,
                                              gender: userProfile?["gender"] as? String,
                                              email: userProfile?["email"] as! String,
                                              phoneNumber: userProfile?["phoneNumber"] as? String,
                                              dateOfBirth: dateFormatter.date(from: userProfile?["dateOfBirth"] as! String),
                                              city: userProfile?["city"] as? String,
                                              state: userProfile?["state"] as? String,
                                              country: userProfile?["country"] as? String,
                                              profilePhotoFirebaseStorageURL: userProfile?["profilePhotoFirebaseStorageURL"] as? String)

                    completion(Constants.Alerts.Messages.successfulSignIn, true, userModel)
                }
            }
        }
    }
    
    // MARK: Sign In With Google
    /// Signs users in using their **Google** credentials.
    ///
    /// - The parameter 'completion' has four arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `UserModel?`: If the authentication was successful, this argument has an object of type `UserModel`. Otherwise, it is nil.
    ///     4. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - viewController: The view controller calling this function
    ///   - completion: An escaping closure with four arguments
    ///
    func signInWithGoogle(withPresenting viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] result, error in
            
            if let error = error {
                print("ERROR SIGNING IN WITH GOOGLE: \(error)")
                /// This occurs when the user presses 'Cancel' when presented with '... wants to use google.com to sign in'.
                completion(Constants.Errors.operationTerminatedByTheUser, false, nil, false)
                return
            }

            guard let googleUser = result?.user,
                  let idToken = googleUser.idToken?.tokenString,
                  let email = googleUser.profile?.email else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: googleUser.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                                
                if let error = error as? AuthErrorCode {
                    self.determineProvider(for: email) { [weak self] provider in
                        print("AUTH ERROR: \(error.errorCode)\n \(error)")
                        
                        self?.determineProvider(for: email) { provider in
                            if(provider == Constants.Providers.noProvider) {
                                /// This indicates that the email address is not in use. Something else is wrong.
                                completion(error.localizedDescription, false, nil, false)
                            } else if(provider == Constants.Providers.emailPassword) {
                                /// The user previously signed up with email address and password.
                                completion(Constants.Alerts.Messages.unsuccessfulSignUpUserAlreadyExists, false, nil, false)
                            } else if(provider != Constants.Providers.google) {
                                /// The user previously signed up with a different provider
                                completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil, false)
                            }
                        }
                    }
                }
                
                if let authResult = authResult,
                   let isNewUser = authResult.additionalUserInfo?.isNewUser {
                    let user = authResult.user
                    
                    if(isNewUser) {
                        /// If the user has signed in with Google for the first time, fetch user's data from Google
                        let userModel = UserModel(uid: authResult.user.uid,
                                                  providerName: Constants.Providers.google,
                                                  firstName: googleUser.profile?.givenName,
                                                  middleName: "",
                                                  lastName: googleUser.profile?.familyName,
                                                  email: email)
                        completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                    } else {
                        /// If this is a returning user, then fetch user's data from Firebase Realtime Database
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .short
                        
                        self.fetchUserProfileFromFirebaseDatabase(uid: user.uid) { userProfile in
                            let userModel = UserModel(uid: user.uid,
                                                      providerName: userProfile?["providerName"] as? String,
                                                      firstName: userProfile?["firstName"] as? String,
                                                      middleName: userProfile?["middleName"] as? String,
                                                      lastName: userProfile?["lastName"] as? String,
                                                      age: userProfile?["age"] as? Int,
                                                      gender: userProfile?["gender"] as? String,
                                                      email: userProfile?["email"] as! String,
                                                      phoneNumber: userProfile?["phoneNumber"] as? String,
                                                      dateOfBirth: dateFormatter.date(from: userProfile?["dateOfBirth"] as! String),
                                                      city: userProfile?["city"] as? String,
                                                      state: userProfile?["state"] as? String,
                                                      country: userProfile?["country"] as? String,
                                                      profilePhotoFirebaseStorageURL: userProfile?["profilePhotoFirebaseStorageURL"] as? String)
                            completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Sign In With Facebook
    /// Signs users in using their **Facebook** credentials.
    ///
    ///  - The parameter 'completion' has four arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `UserModel?`: If the authentication was successful, this argument has an object of type `UserModel`. Otherwise, it is nil.
    ///     4. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - viewController: The view controller calling this function
    ///   - completion: An escaping closure with four arguments
    ///
    func signInWithFacebook(viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void) {
        facebookLoginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { result, error in
            guard let accessToken = AccessToken.current else { return }
            
            /// This condition is true when the user presses 'Cancel' when presented with '... wants to use facebook.com to sign in'.
            if let result = result,
               result.isCancelled {
                completion(Constants.Errors.operationTerminatedByTheUser, false, nil, false)
                return
            }
            
            let request = GraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, middle_name, last_name"])
            request.start { connection, requestResult, error in
                if let error = error {
                    print("ERROR SIGNING IN WITH FACEBOOK \(error)")
                    completion(Constants.Alerts.Messages.unsuccessfulSignUpUserUnknown, false, nil, false)
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                guard let requestResult = requestResult as? [String: String],
                      let email = requestResult["email"] else { return }
                                
                Auth.auth().signIn(with: credential) { authResult, error in
                   
                    if let error = error as? AuthErrorCode {
                        self.determineProvider(for: email) { [weak self] provider in
                            print("AUTH ERROR: \(error.errorCode)\n \(error)")
                            
                            self?.determineProvider(for: email) { provider in
                                if(provider == Constants.Providers.noProvider) {
                                    /// This indicates that the email address is not in use. Something else is wrong.
                                    completion(error.localizedDescription, false, nil, false)
                                } else if(provider == Constants.Providers.emailPassword) {
                                    /// The user previously signed up with email address and password.
                                    completion(Constants.Alerts.Messages.unsuccessfulSignUpUserAlreadyExists, false, nil, false)
                                } else if(provider != Constants.Providers.facebook) {
                                    /// The user previously signed up with a different provider
                                    completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil, false)
                                }
                            }
                        }
                    }
                    
                    if let authResult = authResult,
                       let isNewUser = authResult.additionalUserInfo?.isNewUser {
                        let user = authResult.user
                        
                        if(isNewUser) {
                            /// If the user has signed in with Facebook for the first time, fetch user's data from Facebook
                            let userModel = UserModel(uid: authResult.user.uid,
                                                      providerName: Constants.Providers.facebook,
                                                      firstName: requestResult["first_name"],
                                                      middleName: requestResult["middle_name"],
                                                      lastName: requestResult["last_name"],
                                                      email: email)
                            completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                        } else {
                            /// If this is a returning user, then fetch user's data from Firebase Realtime Database
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            
                            self.fetchUserProfileFromFirebaseDatabase(uid: user.uid) { userProfile in
                                let userModel = UserModel(uid: user.uid,
                                                          providerName: userProfile?["providerName"] as? String,
                                                          firstName: userProfile?["firstName"] as? String,
                                                          middleName: userProfile?["middleName"] as? String,
                                                          lastName: userProfile?["lastName"] as? String,
                                                          age: userProfile?["age"] as? Int,
                                                          gender: userProfile?["gender"] as? String,
                                                          email: userProfile?["email"] as! String,
                                                          phoneNumber: userProfile?["phoneNumber"] as? String,
                                                          dateOfBirth: dateFormatter.date(from: userProfile?["dateOfBirth"] as! String),
                                                          city: userProfile?["city"] as? String,
                                                          state: userProfile?["state"] as? String,
                                                          country: userProfile?["country"] as? String,
                                                          profilePhotoFirebaseStorageURL: userProfile?["profilePhotoFirebaseStorageURL"] as? String)
                                completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Sign Out
    /// Signs users out.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the user was successfully signed out, this argument contains a success message. Otherwise, it contains the reason why the sign out process failed.
    ///     2. `Bool`: Indicating whether the user was signed out or not.
    ///
    /// - Parameter completion: An escaping closure with two arguments
    ///
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void) {
        if(provider == Constants.Providers.google) {
            GIDSignIn.sharedInstance.signOut()
        } else if (provider ==  Constants.Providers.facebook) {
            facebookLoginManager.logOut()
        }
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(Constants.Alerts.Messages.successfulSignOut, true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(Constants.Alerts.Messages.unsuccessfulSignOut, false)
        }
    }
}
