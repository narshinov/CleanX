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
            VStack(alignment: .leading) {
                Text(model.type.title)
                Text("Objects: \(model.objects)")
            }
            Spacer()
            Text(model.sizeString)
            Image(systemName: "chevron.right")
        }
        .onTapGesture {
            action()
        }
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
