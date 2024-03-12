//
//  PhotoVideoCategoryCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI
import Photos

typealias Action = () -> Void

struct PhotoVideoCategoryCell: View {
    let model: Model
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.type.title)
                    .font(.headline)
                Text(R.string.localizable.photoVideoObjects(model.count))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            trailingContainer
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

extension PhotoVideoCategoryCell {
    struct Model: Identifiable {
        let id = UUID()
        let type: DuplicateCategoryType
        var assets: [PHAsset]
        
        var sizeString: String {
            let sizeInBites = assets.map({ $0.fileSizeInBytes }).reduce(Int64.zero, +)
            return ByteCountFormatter.string(fromByteCount: sizeInBites, countStyle: .file)
        }
        
        var count: Int {
            assets.count
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
        model: .init(type: .photo, assets: [])
    )
}
