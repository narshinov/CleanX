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
            type.icon
                .frame(width: 24, height: 24)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
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
        .padding()
        .contentShape(Rectangle())
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
        }
    }
}

private extension MainCategoryCell {

}

#Preview {
    MainCategoryCell(type: .calendar)
        .padding()
}
