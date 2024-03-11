//
//  PhotoVideoService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 1.03.24.
//

import Foundation
import Photos
import UIKit
import Vision
import CoreImage

protocol PhotosServiceProtocol: AnyObject {
    var isDublicateLoaded: Bool { get }
    var isWithTextLoaded: Bool { get }
    var delegate: PhotosUseCaseImplDelegate? { get set }

    var duplicateAssets: [PHAsset] { get set }
    var videoAssets: [PHAsset] { get set }
    var screenshotAssets: [PHAsset] { get set }
    var withTextAssets: [PHAsset] { get set }

    func requestAcess(completion: @escaping (Bool) -> Void)
    func dublicateBackground()
    func withTextBackground()
    func fetchVideoAssets()

    func fetchImage(_ asset: PHAsset, size: CGSize, completion: @escaping (PhotoModel) -> Void)
    func deleteAssets(assets: [PHAsset], completion: @escaping (Bool) -> Void)
    func fetchVideo(asset: PHAsset, completion: @escaping (AVAsset?) -> Void)
}

public protocol PhotosUseCaseImplDelegate {
    func allDublicateDownload()
    func allWithTextDownload()
}

final class PhotoVideoService {
    
    typealias PhotoWithAsset = (CIImage?, PHAsset)
    
    // MARK: Internal

    var isDublicateLoaded: Bool = false
    var isWithTextLoaded: Bool = false
    var delegate: PhotosUseCaseImplDelegate?

    var screenshotAssets: [PHAsset] = []
    var duplicateAssets: [PHAsset] = []
    var withTextAssets: [PHAsset] = []
    var videoAssets: [PHAsset] = []
    

    private let manager = PHCachingImageManager.default()
}

extension PhotoVideoService: PhotosServiceProtocol {
    
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
    
    func fetchVideoAssets() {
        let options = PHFetchOptions()
        options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .video, options: options)
        guard result.count > .zero else { return }
        (0..<result.count).forEach {
            let asset = result.object(at: $0)
            videoAssets.append(asset)
        }
    }
    
    // MARK: Find photo duplicates

    // Start find photo duplicates when app start
    func dublicateBackground() {
        let queue = DispatchQueue(label: "findDublicate", qos: .userInteractive, attributes: .concurrent)
        let queueAsset = DispatchQueue(label: "findAsset", qos: .userInteractive, attributes: .concurrent)
        queue.async {
            self.requestAcess {
                guard $0 else { return }
                queueAsset.async { [weak self] in
                    guard let self else { return }
                    self.findAsset { item in
                        queue.async {
                            self.findDuplicatePhotos(photos: item) {
                                self.duplicateAssets = $0
                                self.isDublicateLoaded = true
                                self.delegate?.allDublicateDownload()
                            }
                        }
                    }
                }
            }
        }
    }

    private func findAsset(compleation: @escaping ([PhotoWithAsset]) -> Void) {
        let group = DispatchGroup()
        var photosWithAssets: [PhotoWithAsset] = []

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        let allAsset = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat

        (0 ..< allAsset.count).indices.forEach {
            group.enter()
            let asset = allAsset.object(at: $0)
            guard asset.mediaSubtypes != .photoScreenshot else {
                group.leave()
                screenshotAssets.append(asset)
                return
            }
            fetchImage(asset, size: .init(width: 10, height: 10)) { response in
                group.leave()
                photosWithAssets.append((response.ciImage, response.asset))
            }
        }

        group.notify(queue: .main) {
            compleation(photosWithAssets)
        }
    }

    private func findDuplicatePhotos(photos: [PhotoWithAsset], compleation: @escaping ([PHAsset]) -> Void) {
        var duplicates: [PHAsset] = []
        photos.enumerated().forEach { index, item in
            if
                let secondItem = photos[safe: index + 1],
                let x = item.0?.featurePrintObservation,
                let y = secondItem.0?.featurePrintObservation,
                x.isSimilar(to: y)
            {
                duplicates.append(secondItem.1)
                if !duplicates.contains(item.1) {
                    duplicates.append(item.1)
                }
                if index == photos.count - 1 { compleation(duplicates) }
            } else {
                if index == photos.count - 1 { compleation(duplicates) }
            }
        }
    }
    
    // MARK: Find photo with text
    
    // Start find photo with text when app start
    func withTextBackground() {
        let queue = DispatchQueue(label: "findWithText", qos: .userInteractive, attributes: .concurrent)
        let queueAsset = DispatchQueue(label: "findTextAsset", qos: .userInteractive, attributes: .concurrent)
        queue.async {
            queueAsset.async { [weak self] in
                guard let self else { return }
                self.fetchAllAssets { response in
                    queue.async {
                        self.findPhotoWithText(response) { assets in
                            self.withTextAssets = assets
                            self.isWithTextLoaded = true
                            self.delegate?.allWithTextDownload()
                        }
                    }
                }
            }
        }
    }
    
    private func fetchAllAssets(completion: @escaping ([PhotoWithAsset]) -> Void) {
        let group = DispatchGroup()
        var photosWithAssets: [PhotoWithAsset] = []

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        let allAsset = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat

        (0 ..< allAsset.count).indices.forEach {
            group.enter()
            let asset = allAsset.object(at: $0)
            fetchImage(asset, size: .init(width: 500, height: 500)) { response in
                group.leave()
                photosWithAssets.append((response.ciImage, response.asset))
            }
        }

        group.notify(queue: .main) {
            completion(photosWithAssets)
        }
    }

    private func findPhotoWithText(_ photos: [PhotoWithAsset], completion: @escaping ([PHAsset]) -> Void) {
        let group = DispatchGroup()
        var assets: [PHAsset] = []
        photos.forEach { model in
            group.enter()
            let request = VNRecognizeTextRequest { request, error in
                guard
                    let observations = request.results as? [VNRecognizedTextObservation],
                    error == nil
                else {
                    group.leave()
                    return
                }
                let text = observations.compactMap({
                    $0.topCandidates(1).first?.string
                }).joined(separator: ", ")
                guard
                    !text.isEmpty,
                    text.count > 30
                else {
                    group.leave()
                    return
                }
                assets.append(model.1)
                group.leave()
            }
            request.recognitionLevel = .fast
            let handler = VNImageRequestHandler(ciImage: model.0 ?? CIImage(), options: [:])
            try? handler.perform([request])
        }

        group.notify(queue: .main) {
            completion(assets)
        }
    }
    
    // MARK: Methods for work with assets
    
    func deleteAssets(assets: [PHAsset], completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        } completionHandler: { isDeleted, error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(isDeleted)
        }
    }
    
    func fetchVideo(asset: PHAsset, completion: @escaping (AVAsset?) -> Void) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .mediumQualityFormat
        manager.requestAVAsset(forVideo: asset, options: options) { video, _, _ in
            completion(video)
        }
    }

    func fetchImage(_ asset: PHAsset, size: CGSize, completion: @escaping (PhotoModel) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        manager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { image, _ in
            completion(.init(asset: asset, image: image.orEmpty))
        }
    }
}
