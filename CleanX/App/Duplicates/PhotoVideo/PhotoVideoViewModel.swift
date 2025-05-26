//
//  PhotoVideoViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Combine
import Foundation
import Photos

@Observable
final class PhotoVideoViewModel {
    typealias Model = DuplicatesCategory.Model
    
    private let photosServise: PhotosServiceProtocol = PhotoVideoService()

    var coordinator = SharedCoordinator()
    var isPhotoAccess: Bool = false
    var duplicatesCategories: [Model] = [
        Model(type: .duplicates, title:  R.string.localizable.photoVideoPhotoDuplicate()),
        Model(type: .video, title:  R.string.localizable.photoVideoVideos()),
        Model(type: .screenshots, title: R.string.localizable.photoVideoScreenshots())
    ]
        
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        requestAcces()
    }
    
    func updateCategory() {
        coordinator.updateCategoryModel
            .sink { [weak self] type, assets in
                guard let self else { return }
                
                if let index = self.duplicatesCategories.firstIndex(where: { $0.type == type }) {
                    if type == .duplicates {
                        duplicatesCategories[index].isLoaded = .constant(false)
                        setupCategory(for: .duplicates, with: photosServise.findDuplicates())
                    } else {
                        self.duplicatesCategories[index].assets = assets
                        
                    }
                }
                
            }
            .store(in: &cancellables)
    }

    private func requestAcces() {
        Task {
            isPhotoAccess = await photosServise.requestAccess()
            guard isPhotoAccess else { return }
            setupCategory()
        }
    }
    
    private func setupCategory() {
        setupCategory(for: .duplicates, with: photosServise.findDuplicates())
        setupCategory(for: .video, with: photosServise.findVideo())
        setupCategory(for: .screenshots, with: photosServise.findScreenshot())
    }
        
    
    private func setupCategory(
        for type: CategoryType,
        with publisher: AnyPublisher<[PHAsset], Never>
    ) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                guard let self = self else { return }

                if let index = self.duplicatesCategories.firstIndex(where: { $0.type == type }) {
                    self.duplicatesCategories[index].assets = assets
                    self.duplicatesCategories[index].isLoaded = .constant(true)
                }
            }
            .store(in: &cancellables)
    }
}
