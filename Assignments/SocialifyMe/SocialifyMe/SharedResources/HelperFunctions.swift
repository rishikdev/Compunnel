//
//  HelperFunctionsClass.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import Foundation

class HelperFunctions {
    static let shared = HelperFunctions()
    private init() {}
    
    func getUserDictionary(userModel: UserModel) -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        /// Not adding profilePhotoURL here as it is specific to a device. The URL obtained from the profile photo is of the image stored on device and not on firebase storage.
        
        var userDictionary = [String: Any]()
        userDictionary["providerName"] = userModel.providerName
        userDictionary["firstName"] = userModel.firstName
        userDictionary["middleName"] = userModel.middleName
        userDictionary["lastName"] = userModel.lastName
        userDictionary["age"] = userModel.age
        userDictionary["gender"] = userModel.gender
        userDictionary["email"] = userModel.email
        userDictionary["phoneNumber"] = userModel.phoneNumber
        userDictionary["dateOfBirth"] = dateFormatter.string(from: userModel.dateOfBirth ?? Date())
        userDictionary["city"] = userModel.city
        userDictionary["state"] = userModel.state
        userDictionary["country"] = userModel.country
        userDictionary["profilePhotoFirebaseStorageURL"] = userModel.profilePhotoFirebaseStorageURL
        
        return userDictionary
    }
    
    func getSharedUser(localUser: LocalUser? = nil, userModel: UserModel? = nil) -> SharedUser {
        var sharedUser = SharedUser(uid: "", email: "")
        if let user = localUser {
            sharedUser.uid = user.uid!
            sharedUser.providerName = user.providerName!
            sharedUser.firstName = user.firstName!
            sharedUser.middleName = user.middleName
            sharedUser.lastName = user.lastName
            sharedUser.age = Int(user.age)
            sharedUser.gender = user.gender
            sharedUser.email = user.email!
            sharedUser.phoneNumber = user.phoneNumber
            sharedUser.dateOfBirth = user.dateOfBirth
            sharedUser.city = user.city
            sharedUser.state = user.state
            sharedUser.country = user.country
            sharedUser.profilePhotoFirebaseStorageURL = user.profilePhotoFirebaseStorageURL
        }
        
        if let user = userModel {
            sharedUser.uid = user.uid
            sharedUser.providerName = user.providerName!
            sharedUser.firstName = user.firstName!
            sharedUser.middleName = user.middleName
            sharedUser.lastName = user.lastName
            sharedUser.age = Int(user.age ?? 0)
            sharedUser.gender = user.gender
            sharedUser.email = user.email
            sharedUser.phoneNumber = user.phoneNumber
            sharedUser.dateOfBirth = user.dateOfBirth
            sharedUser.city = user.city
            sharedUser.state = user.state
            sharedUser.country = user.country
            sharedUser.profilePhotoFirebaseStorageURL = user.profilePhotoFirebaseStorageURL
        }
        
        return sharedUser
    }
}
