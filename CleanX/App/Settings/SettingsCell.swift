//
//  SettingsCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
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

struct SettingsCell: View {
    let type: SettingsType

    var body: some View {
        HStack {
            type.image
                .foregroundStyle(.secondary)
            Text(type.title)
                .fontWeight(.semibold)
            Spacer()
            Image(.chevron.right)
                .foregroundStyle(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
        }
        .onTapGesture {
            handleTap()
        }
    }
    
    private func handleTap() {
        switch type {
        case .contact, .terms, .policy:
            guard let url = URL(string: type.links) else { return }
            UIApplication.shared.open(url)

        case .rate:
            ReviewHandler.requestReviewManually()
        }
        
    }
}

#Preview {
    SettingsCell(type: .contact)
}
