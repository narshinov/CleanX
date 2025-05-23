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

protocol PhotosServiceProtocol: AnyObject {
    var screenshot: [PHAsset] { get }
    var video: [PHAsset] { get }
    
    func requestAccess() async -> Bool

    func delete(_ assets: [PHAsset]) async throws
//    func fetchVideo(asset: PHAsset, completion: @escaping (AVAsset?) -> Void)
//    func fetchImage(_ asset: PHAsset, size: CGSize, completion: @escaping (UIImage, PHAsset) -> Void)
    
    func findDuplicates() async -> [PHAsset]
    func fetchImage(_ asset: PHAsset, size: CGSize) async -> (UIImage, PHAsset)
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
    
    func findDuplicates() async -> [PHAsset] {
        await withCheckedContinuation { continuation in
            findDuplicates { assets in
                continuation.resume(with: .success(assets))
            }
        }
    }
    
    private func findDuplicates(completion: @escaping ([PHAsset]) -> Void) {
        fetchPhotosForDuplicates { response in
            var duplicates: [PHAsset] = []
            response.enumerated().forEach { index, item in
                if
                    let secondItem = response[safe: index + 1],
                    let x = item.0.featurePrintObservation,
                    let y = secondItem.0.featurePrintObservation,
                    x.isSimilar(to: y)
                {
                    duplicates.append(secondItem.1)
                    if !duplicates.contains(item.1) {
                        duplicates.append(item.1)
                    }
                    if index == response.count - 1 { 
                        completion(duplicates)
                    }
                } else {
                    if index == response.count - 1 {
                        completion(duplicates)
                    }
                }
            }
        }
    }
    
    private func fetchPhotosForDuplicates(completion: @escaping ([(CIImage, PHAsset)]) -> Void) {
        let group = DispatchGroup()
        let size = CGSize(width: 10, height: 10)
        var result: [(CIImage, PHAsset)] = []
        photo.forEach {
            group.enter()
            fetchImage($0, size: size) { image, asset in
                result.append((CIImage(image: image).orEmpty, asset))
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .background)) {
            completion(result)
        }
    }
    
    func fetchImage(_ asset: PHAsset, size: CGSize) async -> (UIImage, PHAsset) {
        await withCheckedContinuation { continuation in
            fetchImage(asset, size: size) { image, asset in
                continuation.resume(with: .success((image, asset)))
            }
        }
    }
    
    private func fetchImage(_ asset: PHAsset, size: CGSize, completion: @escaping (UIImage, PHAsset) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options) { image, _ in
            completion(image.orEmpty, asset)
        }
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
