//
//  PhotoPreviewView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.04.24.
//

import SwiftUI

struct PhotoPreviewView: View {    
    @State private var model: PhotoPreviewViewModel
    
    init(model: PhotoPreviewViewModel) {
        self.model = model
    }
    
    var body: some View {
        model.photo
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    PhotoPreviewView(model: .init(asset: .init()))
}
