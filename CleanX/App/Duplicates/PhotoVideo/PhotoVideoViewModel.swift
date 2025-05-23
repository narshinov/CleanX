//
//  PhotoVideoViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Foundation

final class PhotoVideoViewModel: ObservableObject {    
    private let photosServise: PhotosServiceProtocol = PhotoVideoService()

    var isDuplicateLoaded = false
    
    var duplicates: PhotoVideoCategoryCell.Model = .init(type: .photo, assets: [])
    
    var video: PhotoVideoCategoryCell.Model {
        .init(type: .video, assets: photosServise.video)
    }
    
    var screenshots: PhotoVideoCategoryCell.Model {
        .init(type: .screenshot, assets: photosServise.screenshot)
    }
    
    func requestAcces() {
        Task {
            let isAvailable = await photosServise.requestAccess()
            guard isAvailable else { return }
            findDuplicates()
        }
    }
    
    private func findDuplicates() {
        Task {
            let duplicatesAssets = await photosServise.findDuplicates()
            duplicates.assets = duplicatesAssets
            isDuplicateLoaded = true
        }
    }
}
