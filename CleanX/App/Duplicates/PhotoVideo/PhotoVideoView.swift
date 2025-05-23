//
//  PhotoVideoView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct PhotoVideoView: View {
    @ObservedObject private var viewModel = PhotoVideoViewModel()
    
    init() {
        viewModel.requestAcces()
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                NavigationLink {
                    ReviewDuplicatesView(
                        model: .init(assets: viewModel.duplicates.assets)
                    )
                } label: {
                    PhotoVideoCategoryCell(
                        isLoaded: $viewModel.isDuplicateLoaded,
                        model: viewModel.duplicates
                    )
                }.disabled(!viewModel.isDuplicateLoaded)
                
                NavigationLink {
                    ReviewDuplicatesView(
                        model: .init(assets: viewModel.video.assets)
                    )
                } label: {
                    PhotoVideoCategoryCell(
                        isLoaded: .constant(true),
                        model: viewModel.video
                    )
                }
                
                NavigationLink {
                    ReviewDuplicatesView(
                        model: .init(assets: viewModel.screenshots.assets)
                    )
                } label: {
                    PhotoVideoCategoryCell(
                        isLoaded: .constant(true),
                        model: viewModel.screenshots
                    )
                }

                Spacer()
            }
            .buttonStyle(.plain)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(R.string.localizable.photoVideoTitle())

        }
    }
}

#Preview {
    NavigationStack {
        PhotoVideoView()
    }
}
