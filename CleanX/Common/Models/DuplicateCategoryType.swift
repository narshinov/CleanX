//
//  DuplicateCategoryType.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

enum DuplicateCategoryType {
    case photo
    case video
    case screenshot
    
    var title: String {
        switch self {
        case .photo:
            R.string.localizable.photoVideoPhotoDuplicate()

        case .video:
            R.string.localizable.photoVideoVideos()

        case .screenshot:
            R.string.localizable.photoVideoScreenshots()

        }
    }
}
