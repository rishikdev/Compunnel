//
//  SignedInHomeViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 08/03/23.
//

import UIKit

/// `ViewModel` class for ``OnboardingViewController``.
///
/// - Handles functionalities related to **signing users in** using `Email + Password`, `Google`, and `Facebook`.
///
/// - Functions:
///     - ``signInWithEmailPassword(email:password:completion:)``
///     - ``signInWithGoogle(currentVewController:completion:)``
///     - ``signInWithFacebook(currentViewController:completion:)``
///     - ``createUserProfileInFirebaseDatabase(userModel:completion:)``
///
class OnboardingViewModel {
    
    // MARK: - Sign In With Email And Password
    /// Signs users in using their email address and password.
    ///
    /// - Calls ``FirebaseManager/signInWithEmailPassword(email:password:completion:)`` function.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///
    /// - Parameters:
    ///   - email: The email address of the user
    ///   - password: The password of the user
    ///   - completion: An escaping closure with two arguments
    ///
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool) -> Void) {
        FirebaseAuthenticationManager.shared.signInWithEmailPassword(email: email, password: password) { signInMessage, isSignInSuccessful, userModel in
            if(isSignInSuccessful) {
                FirebaseStorageManager.shared.downloadProfilePhotoFromFirebaseStorage(uid: userModel!.uid) { downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                    DispatchQueue.main.async {
                        if(isProfilePhotoDownloaded) {
                            CoreDataManager.shared.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: downloadedProfilePhotoURL)
                        } else {
                            CoreDataManager.shared.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: nil)
                        }
                        SharedUser.shared.localUser = CoreDataManager.shared.fetchLocalUsers()[0]
                        
                        completion(signInMessage, isSignInSuccessful)
                    }
                }
            } else {
                completion(signInMessage, isSignInSuccessful)
            }
        }
    }
    
    // MARK: - Sign In With Google
    /// Signs users in using their Google credentials.
    ///
    /// - Calls ``FirebaseManager/signInWithGoogle(withPresenting:completion:)`` function.
    /// - The parameter 'completion' has three arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - currentViewController: The view controller calling this function
    ///   - completion: An escaping closure with three arguments
    ///
    func signInWithGoogle(currentVewController: UIViewController, completion: @escaping (String, Bool, Bool) -> Void) {
        FirebaseAuthenticationManager.shared.signInWithGoogle(withPresenting: currentVewController) { signInMessage, isSignInSuccessful, userModel, isNewUser in
            if(isSignInSuccessful) {
                FirebaseStorageManager.shared.downloadProfilePhotoFromFirebaseStorage(uid: userModel!.uid) { downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                    DispatchQueue.main.async {
                        if(isProfilePhotoDownloaded) {
                            CoreDataManager.shared.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: downloadedProfilePhotoURL)
                        } else {
                            CoreDataManager.shared.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: nil)
                        }
                        SharedUser.shared.localUser = CoreDataManager.shared.fetchLocalUsers()[0]
                        
                        completion(signInMessage, isSignInSuccessful, isNewUser)
                    }
                }
            } else {
                completion(signInMessage, isSignInSuccessful, isNewUser)
            }
        }
    }
    
    // MARK: - Sign In With Facebook
    /// Signs users in using their Facebook credentials.
    ///
    ///  - Calls ``FirebaseManager/signInWithFacebook(viewController:completion:)`` function.
    ///  - The parameter 'completion' has three arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     4. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - currentViewController: The view controller calling this function
    ///   - completion: An escaping closure with three arguments
    ///
    func signInWithFacebook(currentViewController: UIViewController, completion: @escaping (String, Bool, Bool) -> Void) {
        FirebaseAuthenticationManager.shared.signInWithFacebook(viewController: currentViewController) { signInMessage, isSignInSuccessful, userModel, isNewUser in
            if(isSignInSuccessful) {
                FirebaseStorageManager.shared.downloadProfilePhotoFromFirebaseStorage(uid: userModel!.uid) { downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                    DispatchQueue.main.async {
                        if(isProfilePhotoDownloaded) {
                            CoreDataManager.shared.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: downloadedProfilePhotoURL)
                        } else {
                            CoreDataManager.shared.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: nil)
                        }
                        SharedUser.shared.localUser = CoreDataManager.shared.fetchLocalUsers()[0]
                        completion(signInMessage, true, isNewUser)
                    }
                }
            } else {
                completion(signInMessage, false, isNewUser)
            }
        }
    }
    
    // MARK: - Create User Profile In Firebase Database
    /// Creates user's profile in Firebase Realtime Database
    ///
    /// - Creates a `UserModel` object and converts it to a dictionary.
    /// - Calls ``FirebaseManager/createUserProfileInFirebaseDatabase(uid:userDictionary:completion:)`` function.
    /// - If the users sign up using **Email and Password**, their profile is created using the information obtained from the sign up page.
    /// - If the users sign up using **Google**, their profile is created using their`first name` and `last name` obtained from Google.
    /// - If the users sign up using **Facebook**, their profile is created using their`first name`, `middle name` and `last name` obtained from Facebook.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully created in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile creation failed.
    ///     2. `Bool`: Indicating whether the profile was created or not.
    ///
    /// - Parameters:
    ///   - user: An object of type `UserModel`
    ///   - completion: An escaping closure with two arguments
    ///
    func createUserProfileInFirebaseDatabase(userModel: UserModel, completion: @escaping (String, Bool) -> Void) {
        let userDictionary = HelperFunctions.shared.getUserDictionary(userModel: userModel)
        FirebaseRealtimeDatabaseManager.shared.createUserProfileInFirebaseDatabase(uid: userModel.uid, userDictionary: userDictionary) { message, isProfileCreated in completion(message, isProfileCreated) }
    }
}
