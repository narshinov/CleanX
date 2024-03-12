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
                ForEach(model.categories) { item in
                    NavigationLink {
                        ReviewDuplicatesView(model: .init(assets: item.assets))
                    } label: {
                        PhotoVideoCategoryCell(model: item)
                    }.buttonStyle(.plain)
                }
                Spacer()
            }
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
