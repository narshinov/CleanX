//
//  PhotoVideoView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct PhotoVideoView: View {
    private var viewModel = PhotoVideoViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.isPhotoAccess {
                categories
                    .buttonStyle(.plain)
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(R.string.localizable.photoVideoTitle())
                    .onAppear {
                        viewModel.updateCategory()
                    }
            } else {
                placeholder
            }
        }
    }
    
    var categories: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.duplicatesCategories, id: \.title) { model in
                NavigationLink {
                    ReviewDuplicatesView(
                        viewModel: .init(
                            type: model.type,
                            assets: model.assets,
                            coordinator: viewModel.coordinator
                        )
                    )
                } label: {
                    DuplicatesCategory(model: model)
                }
                .disabled(!model.isLoaded.wrappedValue)
            }

            Spacer()
        }
    }
    
    var placeholder: some View {
        VStack {
            Text("There is no access to photo and video")
            Text("Allow access in the settings")
        }
    }
}

#Preview {
    NavigationStack {
        PhotoVideoView()
    }
}
