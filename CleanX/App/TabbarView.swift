//
//  TabbarView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("CleanX", systemImage: "magnifyingglass")
                }
            
            PhotoVideoView()
                .tabItem {
                    Label("Photo&Video", systemImage: "photo.on.rectangle")
                }
        }
        .tint(.black)
    }
}

#Preview {
    TabbarView()
}
