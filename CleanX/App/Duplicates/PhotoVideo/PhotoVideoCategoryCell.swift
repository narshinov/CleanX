//
//  PhotoVideoCategoryCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI
import Photos

struct PhotoVideoCategoryCell: View {
    @Binding var isLoaded: Bool
    var model: Model
    
    var body: some View {
        HStack {
            text
            Spacer()
            size
                .foregroundStyle(.secondary)
        }
        .backgroundContainer()
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
    var text: some View {
        VStack(alignment: .leading) {
            Text(model.type.title)
                .font(.headline)
            Text(R.string.localizable.photoVideoObjects(model.count))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    var size: some View {
        if isLoaded {
            Text(model.sizeString)
            Image(.chevron.right)
        } else {
            ProgressView()
        }
    }
}

#Preview {
    PhotoVideoCategoryCell(
        isLoaded: .constant(false),
        model: .init(type: .photo, assets: [])
    )
}
