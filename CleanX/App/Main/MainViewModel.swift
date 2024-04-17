//
//  MainViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 1.03.24.
//

import Foundation

final class MainViewModel: ObservableObject {
    private let analyticService: AnalyticServiceProtocol = AnalyticService()
    
    func sendEvent() {
        analyticService.sendEvent(.appLaunch)
    }
}
