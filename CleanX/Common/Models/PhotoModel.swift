//
//  PhotoModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 11.03.24.
//

import UIKit
import Photos

struct PhotoModel {
    let asset: PHAsset
    var image: UIImage
    
    var ciImage: CIImage {
        image.ciImage.orEmpty
    }
}
