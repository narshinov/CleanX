//
//  ReviewDuplicatesViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI
import Photos
@Observable
final class ReviewDuplicatesViewModel {
    let assets: [PHAsset]
    
    init(assets: [PHAsset]) {
        self.assets = assets
    }
    
    private let photoService: PhotosServiceProtocol = PhotoVideoService()
    
    var datasource: [ReviewDuplicatesCellModel] = []
    
    var selectedItems: Int {
        datasource.filter({ $0.isSelected }).count
    }
    
    func selectAll() {
        datasource = datasource.map {
            var newItem = $0
            newItem.isSelected = true
            return newItem
        }
    }
    
    func deselectAll() {
        datasource = datasource.map {
            var newItem = $0
            newItem.isSelected = false
            return newItem
        }
    }
    
    func selectAllTapped(_ isSelected: Bool) {
        datasource = datasource.map {
            var newItem = $0
            newItem.isSelected = !isSelected
            return newItem
        }
    }
    
    func fetchImages() {
        let size = CGSize(width: 500, height: 500)
        assets.forEach {
            photoService.fetchImage($0, size: size) { [weak self] image, asset in
                self?.datasource.append(.init(image: image))
            }
        }
        
    }
    
    func deleteItems() {
        
    }
}
