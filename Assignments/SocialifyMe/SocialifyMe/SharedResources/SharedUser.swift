//
//  SharedUser.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 10/03/23.
//

import Foundation

struct SharedUser {
    
    var uid: String
    var providerName: String?
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var age: Int?
    var gender: String?
    var email: String
    var phoneNumber: String?
    var dateOfBirth: Date?
    var city: String?
    var state: String?
    var country: String?
    var profilePhotoFirebaseStorageURL: String?
}
