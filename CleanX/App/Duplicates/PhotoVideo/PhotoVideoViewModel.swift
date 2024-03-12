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
    private var screenshootAssets: [PHAsset] = []
    
    var categories: [PhotoVideoCategoryCell.Model] {
        [
            .init(type: .photo, assets: duplicateAssets),
            .init(type: .video, assets: []),
            .init(type: .screenshot, assets: screenshootAssets),
            .init(type: .text, assets: []),
            .init(type: .blure, assets: [])
        ]
    }
    
    func requestAcces() {
        photosServise.requestAcess { [weak self] isAvailable in
            guard isAvailable else { return }
            self?.fetchPhotoDuplicates()
            
        }
    }
    
    private func fetchPhotoDuplicates() {
        photosServise.fetchDuplicatesAssets { [weak self] in
            guard let self else { return }
            self.duplicateAssets = $0
            self.screenshootAssets = photosServise.screenshotAssets
        }
        
        
    }
    
    private func fetchImages() {
        let size = CGSize(width: 100, height: 100)

    }
}
