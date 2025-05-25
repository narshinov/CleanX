//
//  SharedCoordinator.swift
//  CleanX
//
//  Created by Никита Аршинов on 25.05.25.
//

import Combine
import Photos

class SharedCoordinator {
    let updateCategoryModel = PassthroughSubject<(CategoryType, [PHAsset]), Never>()
}
