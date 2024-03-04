//
//  ContainerCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 1.03.24.
//

import SwiftUI
import SafeSFSymbols

struct ContainerCellModel {
    var icon: SafeSFSymbol
    var title: String
    var subtitle: String
    var detail: String
    
    init(
        icon: SafeSFSymbol,
        title: String,
        subtitle: String,
        detail: String = ""
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
    }
}

struct ContainerCell: View {
    
    let model: ContainerCellModel
    
    var body: some View {
        HStack {
            textContainer
            Spacer()
            detail
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.background.secondary)
        }
    }
}

private extension ContainerCell {
    var label: some View {
        HStack {
            Image(model.icon)
            Text(model.title)
                .font(.body)
        }
    }
    
    var textContainer: some View {
        VStack(alignment: .leading) {
            label
            Text(model.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var detail: some View {
        Group {
            Text(model.detail)
            Image(.chevron.right)
        }
        .foregroundStyle(.secondary)
    }
    
}

#Preview {
    ContainerCell(
        model: .init(
            icon: .photo.onRectangleAngled,
            title: "Duplicated Photos",
            subtitle: "Objects: 72",
            detail: "256 MB"
        )
    ).padding()
}
