//
//  MainCategoryCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI
import SafeSFSymbols

struct MainCategoryCell: View {
    let type: MainCategoryType

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                iconWithText
                Text(type.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(nil)
            }
            Spacer()
            Image(.chevron.right)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.background.secondary)
        }
    }
}

private extension MainCategoryCell {
    var iconWithText: some View {
        HStack {
            Image(type.icon)
            Text(type.title)
                .font(.body)
        }
    }
}

#Preview {
    MainCategoryCell(type: .photo)
        .padding()
}
