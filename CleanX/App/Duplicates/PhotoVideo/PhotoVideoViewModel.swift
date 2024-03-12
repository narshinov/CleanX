//
//  PhotoVideoViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Foundation
import Photos

@Observable
final class PhotoVideoViewModel {
    private let photosServise: PhotosServiceProtocol = PhotoVideoService()
    
    private var duplicateAssets: [PHAsset] = []
    
    var categories: [PhotoVideoCategoryCell.Model] {
        [
            .init(type: .photo, assets: duplicateAssets),
            .init(type: .video, assets: photosServise.video),
            .init(type: .screenshot, assets: photosServise.screenshot)
        ]
    }
    
    func requestAcces() {
        Task {
            let isAvailable = await photosServise.requestAccess()
            guard isAvailable else { return }
            findDuplicates()
            
        }
    }
    
    func findDuplicates() {
        photosServise.findDuplicates { [weak self] in
            self?.duplicateAssets = $0
        }
    }
    
}
