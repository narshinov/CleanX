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
    func requestAccess() async -> Bool
    func findDuplicates() -> AnyPublisher<[PHAsset], Never>
    func findVideo() -> AnyPublisher<[PHAsset], Never>
    func findScreenshot() -> AnyPublisher<[PHAsset], Never>
    func fetchImage(_ asset: PHAsset, size: CGSize) -> AnyPublisher<(UIImage, PHAsset), Never>
    func delete(_ asset: [PHAsset]) -> AnyPublisher<Void, Error>
}

final class PhotoVideoService {
    private let manager = PHCachingImageManager.default()
}

extension PhotoVideoService: PhotosServiceProtocol {
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
    
    func findVideo() -> AnyPublisher<[PHAsset], Never> {
        Future { promise in
            var assets: [PHAsset] = []
            let options = PHFetchOptions()
            options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
            let result =  PHAsset.fetchAssets(with: .video, options: options)
            (0..<result.count).forEach {
                let asset = result.object(at: $0)
                assets.append(asset)
            }
            promise(.success(assets))
        }
        .eraseToAnyPublisher()
    }
    
    func findScreenshot() -> AnyPublisher<[PHAsset], Never> {
        Future { promise in
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
            promise(.success(assets))
        }
        .eraseToAnyPublisher()
    }
    
    func findDuplicates() -> AnyPublisher<[PHAsset], Never> {
        return fetchPhotosForDuplicates()
            .flatMap { response in
                Deferred {
                    Future<[PHAsset], Never> { promise in
                        DispatchQueue.global(qos: .userInitiated).async {
                            var duplicates: [PHAsset] = []
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
                            
                            promise(.success(duplicates))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    


    private func fetchPhotosForDuplicates() -> AnyPublisher<[(CIImage, PHAsset)], Never> {
        let size = CGSize(width: 10, height: 10)

        let publishers = photo.map { asset in
            fetchImage(asset, size: size)
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
    
    func delete(_ asset: [PHAsset]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { completion in
                Task {
                    do {
                        try await PHPhotoLibrary.shared().performChanges {
                            PHAssetChangeRequest.deleteAssets(asset as NSArray)
                        }
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(_ assets: [PHAsset]) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }
    }
}
