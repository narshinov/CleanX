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
                Text("Free up space on your iPhone")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.leading)
                Text("We've got all the tools you need to keep your device clean and organized.")
                Spacer()
                
                
            }
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
