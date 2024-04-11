//
//  PhotoVideoView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct PhotoVideoView: View {

    @State private var model = PhotoVideoViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                NavigationLink {
                    ReviewDuplicatesView(
                        model: .init(assets: model.duplicates.assets)
                    )
                } label: {
                    PhotoVideoCategoryCell(
                        isLoaded: $model.isDuplicateLoaded,
                        model: model.duplicates
                    )
                }
                
                NavigationLink {
                    ReviewDuplicatesView(
                        model: .init(assets: model.video.assets)
                    )
                } label: {
                    PhotoVideoCategoryCell(
                        isLoaded: .constant(true),
                        model: model.video
                    )
                }
                
                NavigationLink {
                    ReviewDuplicatesView(
                        model: .init(assets: model.screenshots.assets)
                    )
                } label: {
                    PhotoVideoCategoryCell(
                        isLoaded: .constant(true),
                        model: model.screenshots
                    )
                }

                Spacer()
            }
            .buttonStyle(.plain)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(R.string.localizable.photoVideoTitle())
            .onAppear {
                model.requestAcces()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhotoVideoView()
    }
}
