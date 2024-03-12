//
//  TabbarView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SwiftUI

struct TabbarView: View {
    @State var tabSelected: Int = .zero

    var body: some View {
        TabView(selection: $tabSelected) {
            MainView(tabSelected: $tabSelected)
                .tag(0)
                .tabItem {
                    Label("CleanX", image: .broomIc)
                }
            
            PhotoVideoView()
                .tag(1)
                .tabItem {
                    Label("Photo&Video", systemImage: "photo.on.rectangle")
                }
            
            ContactsView()
                .tag(2)
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
            
            CalendarView()
                .tag(3)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}

private extension TabbarView {
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    TabbarView()
}
