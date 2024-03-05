//
//  ReviewDuplicatesViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI

@Observable
final class ReviewDuplicatesViewModel {
    var datasource: [ReviewDuplicatesCellModel] = [
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock))
    ]
    
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
    
    func deleteItems() {
        
    }
}
