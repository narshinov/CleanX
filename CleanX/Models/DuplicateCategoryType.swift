//
//  DuplicateCategoryType.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import Foundation

enum DuplicateCategoryType {
    case photo
    case video
    case screenshot
    case text
    
    var title: String {
        switch self {
        case .photo:
            "Duplicated Photos"
        case .video:
            "Videos"
        case .screenshot:
            "Screenshots"
        case .text:
            "Photos with Texts"
        }
    }
}
