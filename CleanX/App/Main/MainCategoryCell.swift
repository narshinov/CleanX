//
//  MainCategoryCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI
import SafeSFSymbols

struct MainCategoryCell: View {
    let model: MainCategoryType

    var body: some View {
        HStack {
            IconWithBackground(model.icon)
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.body)
                Text(model.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(nil)
            }
            .multilineTextAlignment(.leading)
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

#Preview {
    MainCategoryCell(model: .photo)
}
