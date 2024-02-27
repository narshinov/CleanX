//
//  SettingsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(.image)
            }
            .navigationTitle("Settings")
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    SettingsView()
}
