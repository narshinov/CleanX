//
//  PhotoVideoViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import Combine
import Foundation

final class PhotoVideoViewModel: ObservableObject {    
    private let photosServise: PhotosServiceProtocol = PhotoVideoService()

    @Published var isDuplicateLoaded = false
    
    var duplicates: PhotoVideoCategoryCell.Model = .init(type: .photo, assets: [])
    
    var video: PhotoVideoCategoryCell.Model {
        .init(type: .video, assets: photosServise.video)
    }
    
    var screenshots: PhotoVideoCategoryCell.Model {
        .init(type: .screenshot, assets: photosServise.screenshot)
    }
    
    private var cancellables = Set<AnyCancellable>()

    func requestAcces() {
        Task {
            let isAvailable = await photosServise.requestAccess()
            guard isAvailable else { return }
            findDuplicates()
        }
    }
    
    func findDuplicates() {
        photosServise.findDuplicates()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isDuplicateLoaded = true
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { assets in
                self.duplicates.assets = assets
            })
            .store(in: &cancellables)
    }
}
