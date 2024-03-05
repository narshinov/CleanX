//
//  PhotoVideoService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 1.03.24.
//

import Foundation
import Combine
import Photos
import SwiftUI

final class PhotoVideoService {
    private let manager = PHCachingImageManager.default()
    
}

extension PhotoVideoService {
    private var photoAssets: [PHAsset] {
        var assets: [PHAsset] = []
        let options = PHFetchOptions()
        options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        guard result.count > .zero else { return [] }
        (0..<result.count).forEach {
            let asset = result.object(at: $0)
            assets.append(asset)
        }
        return assets
    }
    
    func requestAcess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined, .restricted, .denied:
                completion(false)

            case .authorized, .limited:
                completion(true)
                
            @unknown default:
                completion(false)
            }
        }
    }
    
    func fetchImage(_ asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void){
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        manager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { image, _ in
            completion(image)
        }
    }
}
