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
            VStack(alignment: .leading, spacing: 32) {
                Text(R.string.localizable.photoVideoSubtitle())
                    .font(.system(size: 20))
                categoriesContainer
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(R.string.localizable.photoVideoTitle())
            .onAppear {
                model.requestAcces()
            }
        }
    }
}

private extension PhotoVideoView {
    var categoriesContainer: some View {
        VStack(spacing: 16) {
            ForEach(model.categories) { item in
                NavigationLink {
                    ReviewDuplicatesView(model: .init(assets: item.assets))
                } label: {
                    PhotoVideoCategoryCell(model: item)
                }.buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhotoVideoView()
    }
}
