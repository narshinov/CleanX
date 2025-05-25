//
//  DuplicatesCategory.swift
//  CleanX
//
//  Created by Никита Аршинов on 25.05.25.
//

import SwiftUI
import Photos

struct DuplicatesCategory: View {
    let model: Model

    var body: some View {
        HStack {
            text
            Spacer()
            size
        }
        .backgroundContainer()        
    }
}

extension DuplicatesCategory {
    struct Model {
        let type: CategoryType
        let title: String
        var assets: [PHAsset] = []
        var isLoaded: Binding<Bool> = .constant(false)
        
        var size: String {
            let sizeInBites = assets.map({ $0.fileSizeInBytes }).reduce(Int64.zero, +)
            return ByteCountFormatter.string(fromByteCount: sizeInBites, countStyle: .file)
        }
    }
}

private extension DuplicatesCategory {
    var text: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
            Text(R.string.localizable.photoVideoObjects(model.assets.count))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    var size: some View {
        if model.isLoaded.wrappedValue {
            Text(model.size)
            Image(.chevron.right)
        } else {
            ProgressView()
        }
    }
}

#Preview {
    let model = DuplicatesCategory.Model(
        type: .duplicates,
        title: "Test",
        isLoaded: .constant(false)
    )
    DuplicatesCategory(model: model)
}
