//
//  SettingsCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

enum SettingsType: CaseIterable {
    case contact
    case share
    case policy
    case terms
    case rate
    
    var title: String {
        switch self {
        case .contact:
            R.string.localizable.settingsContactUs()
        case .share:
            R.string.localizable.settingsShareUs()
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
        case .share:
            Image(.square.andArrowUp)
        case .policy:
            Image(.hand.raised)
        case .terms:
            Image(.doc.text)
        case .rate:
            Image(.star)
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
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
        }
    }
}

#Preview {
    SettingsCell(type: .contact)
}
