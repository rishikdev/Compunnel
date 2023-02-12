//
//  VideoViewModel.swift
//  Videos
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class VideoViewModel {
    var videos:[VideoModel] = []
    
    func getVideos(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.fetchVideos(from: Constants.urls.videos.rawValue) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.videos = videos
                completion()
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getVideo(at index: Int) -> VideoModel {
        videos[index]
    }
}
