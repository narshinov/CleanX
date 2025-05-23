//
//  MainView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct MainView: View {
    @Binding var tabSelected: Int
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                header
                categories
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(R.string.localizable.commonAppName())
            .toolbar {
                settings
            }
        }
    }
}

private extension MainView {
    var settings: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: SettingsView()) {
                Image(.gearshape)
                    .tint(gradient)
            }
        }
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(R.string.localizable.homeTitle())
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.leading)
            Text(R.string.localizable.homeSubtitle())
        }
    }

    var categories: some View {
        ForEach(MainCategoryType.allCases, id: \.self) { type in
            MainCategoryCell(type: type)
                .onTapGesture {
                    selectTab(type)
                }
        }
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    func selectTab(_ model: MainCategoryType) {
        switch model {
        case .photo:
            tabSelected = 1
        case .contacts:
            tabSelected = 2
        case .calendar:
            tabSelected = 3
        }
    }
}

#Preview {
    MainView(tabSelected: .constant(.zero))
}
