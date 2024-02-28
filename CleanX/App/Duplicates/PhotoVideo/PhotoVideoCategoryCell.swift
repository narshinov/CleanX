//
//  PhotoVideoCategoryCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

typealias Action = () -> Void

struct PhotoVideoCategoryCell: View {
    struct Model: Hashable {
        let type: DuplicateCategoryType
        var objects: Int
        var sizeInBites: Int64
        
        var sizeString: String {
            ByteCountFormatter.string(fromByteCount: sizeInBites, countStyle: .file)
        }
    }

    let model: Model
    var action: Action
    
    var body: some View {
        HStack {
            IconWithBackground(model.type.icon, backgroundStyle: .quinary)
            textContainer
            Spacer()
            trailingContainer
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.background.secondary)
        }
        .onTapGesture {
            action()
        }
    }
}

private extension PhotoVideoCategoryCell {
    var textContainer: some View {
        VStack(alignment: .leading) {
            Text(model.type.title)
                .font(.body)
            Text(R.string.localizable.photoVideoObjects(model.objects))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    var trailingContainer: some View {
        HStack {
            Text(model.sizeString)
            Image(.chevron.right)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    PhotoVideoCategoryCell(
        model: .init(
            type: .photo,
            objects: 72,
            sizeInBites: 3435973836
        )
    ) {
        
    }
}
