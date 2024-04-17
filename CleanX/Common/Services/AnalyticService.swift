//
//  AnalyticService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 17.04.24.
//

import Foundation
import AmplitudeSwift

enum EventType: String {
    case appLaunch
    case photoVideoDeleted
    case сontactDeleted
    case contactMerged
    case eventDeleted
}

protocol AnalyticServiceProtocol: AnyObject {
    func sendEvent(_ type: EventType)
}

final class AnalyticService {
    private let amplitude = Amplitude(configuration: Configuration(apiKey: "76aaf9a81b1dd6e70332d93bb279cf59"))
}

extension AnalyticService: AnalyticServiceProtocol {
    func sendEvent(_ type: EventType) {
        amplitude.track(eventType: type.rawValue)
    }
}
