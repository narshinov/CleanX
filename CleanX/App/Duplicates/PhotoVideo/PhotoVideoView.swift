//
//  PhotoVideoView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct PhotoVideoView: View {
    private let categories: [PhotoVideoCategoryCell.Model] = [
        .init(type: .photo, objects: 72, sizeInBites: 3435973836),
        .init(type: .video, objects: 72, sizeInBites: 3435973836),
        .init(type: .screenshot, objects: 72, sizeInBites: 3435973836),
        .init(type: .text, objects: 72, sizeInBites: 3435973836)
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                Text("Find and delete similar photos, videos, screenshots, and photos with text")
                    .font(.system(size: 20))
                
                VStack(spacing: 32) {
                    ForEach(categories, id: \.self) {
                        PhotoVideoCategoryCell(model: $0) {
                            
                        }
                    }
                }
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Photo and video")
        }
        
    }
}

#Preview {
    NavigationStack {
        PhotoVideoView()
    }
    
}
