//
//  ReviewDuplicatesViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Photos
import Combine

enum CategoryType {
    case duplicates
    case video
    case screenshots
}

@Observable
final class ReviewDuplicatesViewModel: ObservableObject {
    let type: CategoryType
    let coordinator: SharedCoordinator
    var models: [DuplicateModel] = []
    
    var selectedItemsCount: Int {
        models.filter({ $0.isSelected }).count
    }
    
    private let photoService: PhotosServiceProtocol = PhotoVideoService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(type: CategoryType, assets: [PHAsset], coordinator: SharedCoordinator) {
        self.type = type
        self.coordinator = coordinator
        fetchImageFrom(assets)
    }
    
    func delete() {
        let assets = models.filter({ $0.isSelected }).map { $0.asset }
        photoService.delete(assets)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.models = self.models.filter { !$0.isSelected }
                    self.updateCategory()
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func updateCategory() {
        let assets = models.map { $0.asset }
        coordinator.updateCategoryModel.send((type, assets))
    }
    
    private func fetchImageFrom(_ assets: [PHAsset]) {
        let size = CGSize(width: 500, height: 500)
        let publishers = assets.map { asset in
            photoService.fetchImage(asset, size: size)
                .map { response in
                    let image = response.0.toImage
                    let asset = response.1
                    return DuplicateModel(image: image, asset: asset)
                }
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.models = $0
            }
            .store(in: &cancellables)
    }
}
