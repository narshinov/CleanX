//
//  ReviewDuplicatesCellModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 12.03.24.
//

import SwiftUI
import Photos

struct ReviewDuplicatesCellModel: Identifiable {
    let id = UUID()
    let image: Image
    let asset: PHAsset
    var isSelected = false
}
