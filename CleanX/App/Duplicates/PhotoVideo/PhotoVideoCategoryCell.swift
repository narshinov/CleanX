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
        
        static var mockObject: Model {
            .init(
                type: .photo,
                objects: 72,
                sizeInBites: 3435973836
            )
        }
    }

    let model: Model
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.type.title)
                    .font(.headline)
                Text(R.string.localizable.photoVideoObjects(model.objects))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            trailingContainer
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
        }
    }
}

private extension PhotoVideoCategoryCell {
    var trailingContainer: some View {
        Group {
            Text(model.sizeString)
            Image(.chevron.right)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    PhotoVideoCategoryCell(
        model: PhotoVideoCategoryCell.Model.mockObject
    )
}
