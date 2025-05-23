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
    
    private let photoService: PhotosServiceProtocol = PhotoVideoService()
    private let analyticService: AnalyticServiceProtocol = AnalyticService()
    
    var datasource: [ReviewDuplicatesCellModel] = []
    
    var selectedItemsCount: Int {
        datasource.filter({ $0.isSelected }).count
    }

    let assets: [PHAsset]
    
    init(assets: [PHAsset]) {
        self.assets = assets
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
        Task {
            for asset in assets {
                let result = await photoService.fetchImage(asset, size: size)
                datasource.append(.init(image: result.0.toImage, asset: result.1))
            }
        }
    }
    
    func deleteItems() {
        let assets = datasource.filter({ $0.isSelected }).map { $0.asset }
        Task {
            try await photoService.delete(assets)
            analyticService.sendEvent(.photoVideoDeleted)
            datasource = datasource.filter { !$0.isSelected }
            ReviewHandler.requestReview()
        }
    }
}
