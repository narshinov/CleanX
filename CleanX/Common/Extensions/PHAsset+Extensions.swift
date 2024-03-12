//
//  PHAsset+Extensions.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Photos

extension PHAsset {
    var fileSizeInBytes: Int64 {
        let resources = PHAssetResource.assetResources(for: self)
        let fileSize: [Int64] = resources.map {
            guard let unsignedInt64 = $0.value(forKey: "fileSize") as? CLong else { return .zero }
            return Int64(bitPattern: UInt64(unsignedInt64))
        }
        return fileSize.reduce(.zero, +)
    }
}
