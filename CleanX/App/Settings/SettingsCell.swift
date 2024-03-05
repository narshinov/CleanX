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
    case restore
    
    var title: String {
        switch self {
        case .contact:
            "Contact us"
        case .share:
            "Share us"
        case .policy:
            "Privacy policy"
        case .terms:
            "Terms of use"
        case .rate:
            "Rate us"
        case .restore:
            "Restore purchases"
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
        case .restore:
            Image(.arrow.circlepath)
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
