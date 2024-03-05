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
            ScrollView {
                NavigationLink {
                    
                } label: {
                    PremiumCell(title: "Unlock premium features")
                }
                .padding([.top, .horizontal])
                VStack(spacing: 16) {
                    ForEach(SettingsType.allCases, id: \.self) {
                        SettingsCell(type: $0)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Settings")
            .toolbar(.hidden, for: .tabBar)
            .toolbarRole(.editor)
        }
    }
}

#Preview {
    SettingsView()
}
