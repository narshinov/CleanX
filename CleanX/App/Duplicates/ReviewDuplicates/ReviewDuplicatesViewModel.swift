//
//  ReviewDuplicatesViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI
import Photos
import Combine

@Observable
final class ReviewDuplicatesViewModel {
    
    private let photoService: PhotosServiceProtocol = PhotoVideoService()
    private let analyticService: AnalyticServiceProtocol = AnalyticService()
    
    var datasource: [ReviewDuplicatesCellModel] = []
    
    var selectedItemsCount: Int {
        datasource.filter({ $0.isSelected }).count
    }

    let assets: [PHAsset]
    
    private var cancellables = Set<AnyCancellable>()
    
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
        let publishers = assets.map { asset in
            photoService.fetchImage(asset, size: size)
                .map { responce in
                    let image = responce.0.toImage
                    let asset = responce.1
                    return ReviewDuplicatesCellModel(image: image, asset: asset)
                }
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.datasource = items
            }
            .store(in: &cancellables)
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
