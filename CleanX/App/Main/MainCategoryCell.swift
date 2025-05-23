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
            icon
            text
        }
        .backgroundContainer()
    }
}

private extension MainCategoryCell {
    var icon: some View {
        type.icon
            .frame(width: 24, height: 24)
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
    
    var text: some View {
        VStack(alignment: .leading) {
            Text(type.title)
                .font(.headline)
            Text(type.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    MainCategoryCell(type: .calendar)
        .padding()
}
