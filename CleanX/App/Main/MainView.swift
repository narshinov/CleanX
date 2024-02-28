//
//  MainView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(R.string.localizable.homeTitle())
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.leading)
                Text(R.string.localizable.homeSubtitle())
                
                VStack(spacing: 16) {
                    ForEach(MainCategoryType.allCases, id: \.self) {
                        MainCategoryCell(model: $0)
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("CleanX")
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                        .tint(.blue)
                }

            }
            
        }
        
    }
}

#Preview {
    MainView()
}
