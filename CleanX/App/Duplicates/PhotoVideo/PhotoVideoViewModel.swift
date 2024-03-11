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
    
    private var photoAssets: [PHAsset] = []
    
    var categories: [PhotoVideoCategoryCell.Model] {
        [
            .init(type: .photo, assets: photoAssets),
            .init(type: .video, assets: []),
            .init(type: .screenshot, assets: []),
            .init(type: .text, assets: []),
            .init(type: .blure, assets: [])
        ]
    }
    
    func requestAcces() {
        photosServise.requestAcess { [weak self] isAvailable in
            guard isAvailable else { return }
            self?.fetchImages()
        }
    }
    
    private func fetchImages() {
        let size = CGSize(width: 100, height: 100)

    }
}
