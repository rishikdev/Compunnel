//
//  SignedInSettingsViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import UIKit

/// `ViewModel` class for ``SignedInSettingsViewController``.
///
/// - Handles functionalities related to signing out users.
///
/// - Functions:
///     - ``signOut(completion:)``
///     - ``deleteAllLocalUsers(entity:)``
///
class SignedInSettingsViewModel {
    
    // MARK: - Sign Out
    /// Signs users out.
    ///
    /// - Calls ``FirebaseManager/signOut(completion:)` funciton.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the user was successfully signed out, this argument contains a success message. Otherwise, it contains the reason why the sign out process failed.
    ///     2. `Bool`: Indicating whether the user was signed out or not.
    ///
    /// - Parameter completion: An escaping closure with two arguments
    ///
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void) {
        FirebaseManager.shared.signOut(provider: provider) { message, isSignedOut in completion(message, isSignedOut) }
    }
    
    // MARK: - Delete All Local Users
    /// Deletes every object of the `entity` provided.
    ///
    /// Calls ``CoreDataManager/deleteAllLocalUsers(entity:)`` function
    ///
    /// - Parameter entity: Name of the entity the objects of which need to be deleted
    ///
    func deleteAllLocalUsers(entity: String) {
        CoreDataManager.shared.deleteAllLocalUsers(entity: entity)
    }
}
