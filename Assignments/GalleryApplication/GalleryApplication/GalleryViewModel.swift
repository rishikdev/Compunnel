//
//  GalleryViewModel.swift
//  GalleryApplication
//
//  Created by Rishik Dev on 09/02/23.
//

import Foundation

class GalleryViewModel {
    var photos: [GalleryModel] = []
    
    func getPhotos(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.fetchPhotos(from: Constants.urls.photos.rawValue) { [weak self] result in
            switch result {
            case .success(let gallery):
                self?.photos = gallery
                completion()
                
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func getPhoto(at index: Int) -> GalleryModel {
        photos[index]
    }
}
