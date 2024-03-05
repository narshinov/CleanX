//
//  PhotoVideoViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Foundation

@Observable
final class PhotoVideoViewModel {
    let categories: [PhotoVideoCategoryCell.Model] = [
        .init(type: .photo, objects: 72, sizeInBites: 713031680),
        .init(type: .video, objects: 16, sizeInBites: 1761607680),
        .init(type: .screenshot, objects: 34, sizeInBites: 265289728),
        .init(type: .text, objects: 10, sizeInBites: 131072000)
    ]
}
