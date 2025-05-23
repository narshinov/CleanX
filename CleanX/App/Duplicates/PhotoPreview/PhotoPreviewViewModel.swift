//
//  PhotoPreviewViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.04.24.
//

import Foundation
import Photos
import SwiftUI

@Observable
final class PhotoPreviewViewModel {
    private let photosServise: PhotosServiceProtocol = PhotoVideoService()

    var photo: Image = .init(uiImage: UIImage())
    
    init(asset: PHAsset) {
        fetchImage(asset)
    }
    
    private func fetchImage(_ asset: PHAsset) {
        let size = CGSize(
            width: CGFloat(asset.pixelWidth),
            height: CGFloat(asset.pixelHeight)
        )
        Task {
            let result = await photosServise.fetchImage(asset, size: size)
            photo = result.0.toImage
        }
    }
}
