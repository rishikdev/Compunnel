//
//  UserViewModel.swift
//  UserInfo
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class UserViewModel {
    var user: UserModel?
    
    func getUser(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.getUserInfo(from: Constants.urls.userURL.rawValue) { [weak self] (result: Result<UserModel, Error>) in
            switch result {
            case .success(let user):
                self?.user = user
                completion()
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
}
