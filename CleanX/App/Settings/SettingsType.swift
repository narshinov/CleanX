//
//  SettingsType.swift
//  CleanX
//
//  Created by Никита Аршинов on 23.05.25.
//

import SwiftUI

enum SettingsType: CaseIterable {
    case contact
    case policy
    case terms
    case rate
    
    var title: String {
        switch self {
        case .contact:
            R.string.localizable.settingsContactUs()
        case .policy:
            R.string.localizable.settingsPolicy()
        case .terms:
            R.string.localizable.settingsTerms()
        case .rate:
            R.string.localizable.settingsRate()
        }
    }
    
    var image: Image {
        switch self {
        case .contact:
            Image(.ellipsis.message)
        case .policy:
            Image(.hand.raised)
        case .terms:
            Image(.doc.text)
        case .rate:
            Image(.star)
        }
    }
    
    var links: String {
        switch self {
        case .contact:
            return "https://forms.gle/Xiffvd6BjzD55dGYA"
        case .policy:
            return "https://sites.google.com/view/privacy-policy-cleanx"
        case .terms:
            return "https://sites.google.com/view/terms-of-use-cleanx"
        case .rate:
            return ""
        }
    }
}
