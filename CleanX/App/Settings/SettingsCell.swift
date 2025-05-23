//
//  SettingsCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

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
        .backgroundContainer()
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
