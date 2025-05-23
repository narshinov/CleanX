//
//  PhotoVideoService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 1.03.24.
//

import Foundation
import Photos
import UIKit
import CoreImage
import Combine

protocol PhotosServiceProtocol: AnyObject {
    var screenshot: [PHAsset] { get }
    var video: [PHAsset] { get }
    
    func requestAccess() async -> Bool

    func delete(_ assets: [PHAsset]) async throws
    func findDuplicates() -> AnyPublisher<[PHAsset], Never>
    func fetchImage(_ asset: PHAsset, size: CGSize) -> AnyPublisher<(UIImage, PHAsset), Never>
}

final class PhotoVideoService {
    
    private let manager = PHCachingImageManager.default()

}

extension PhotoVideoService: PhotosServiceProtocol {

    var screenshot: [PHAsset] {
        var assets: [PHAsset] = []
        let options = PHFetchOptions()
        options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        options.predicate = .init(
            format: "mediaSubtype == %d",
            PHAssetMediaSubtype.photoScreenshot.rawValue
        )
        let result =  PHAsset.fetchAssets(with: .image, options: options)
        (0..<result.count).forEach {
            let asset = result.object(at: $0)
            assets.append(asset)
        }
        return assets
    }
    
    var video: [PHAsset] {
        var assets: [PHAsset] = []
        let options = PHFetchOptions()
        options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        let result =  PHAsset.fetchAssets(with: .video, options: options)
        (0..<result.count).forEach {
            let asset = result.object(at: $0)
            assets.append(asset)
        }
        return assets
    }
    
    private var photo: [PHAsset] {
        var assets: [PHAsset] = []
        let options = PHFetchOptions()
        options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        (0..<result.count).forEach {
            let asset = result.object(at: $0)
            guard asset.mediaSubtypes != .photoScreenshot else { return }
            assets.append(asset)
        }
        return assets
    }
    
    func requestAccess() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        switch status {
        case .notDetermined, .restricted, .denied:
            return false

        case .authorized, .limited:
            return true
            
        @unknown default:
            return false
        }
    }
    
    func findDuplicates() -> AnyPublisher<[PHAsset], Never> {
        var duplicates: [PHAsset] = []
        return fetchPhotosForDuplicates()
            .map { response in
                for (index, item) in response.enumerated() {
                    guard
                        let secondItem = response[safe: index + 1],
                        let x = item.0.featurePrintObservation,
                        let y = secondItem.0.featurePrintObservation,
                        x.isSimilar(to: y)
                    else { continue }
                    
                    if !duplicates.contains(item.1) {
                        duplicates.append(item.1)
                    }
                    duplicates.append(secondItem.1)
                }
                return duplicates
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchPhotosForDuplicates() -> AnyPublisher<[(CIImage, PHAsset)], Never> {
        let size = CGSize(width: 10, height: 10)

        let publishers = photo.map { asset in
            fetchImage(asset, size: size)
                .subscribe(on: DispatchQueue.global())
                .map { result in
                    let image = CIImage(image: result.0) ?? CIImage()
                    let asset = result.1
                    return (image, asset)
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
    }
    
    func fetchImage(_ asset: PHAsset, size: CGSize) -> AnyPublisher<(UIImage, PHAsset), Never> {
        Future{ [weak self] completion in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            self?.manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options) { image, _ in
                let result = (image ?? UIImage(), asset)
                completion(.success(result))
            }
        }.eraseToAnyPublisher()
    }
    
    private func fetchVideo(asset: PHAsset, completion: @escaping (AVAsset?) -> Void) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .mediumQualityFormat
        manager.requestAVAsset(forVideo: asset, options: options) { video, _, _ in
            completion(video)
        }
    }
    
    func delete(_ assets: [PHAsset]) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }
    }
}
