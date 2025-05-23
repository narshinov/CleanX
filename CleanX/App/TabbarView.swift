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
                    Label(
                        R.string.localizable.commonAppName(),
                        image: .broomIc
                    )
                }
            
            PhotoVideoView()
                .tag(1)
                .tabItem {
                    Label(
                        R.string.localizable.tabbarPhoto(),
                        systemImage: "photo.on.rectangle"
                    )
                }
            
            ContactsView()
                .tag(2)
                .tabItem {
                    Label(
                        R.string.localizable.tabbarContacts(),
                        systemImage: "person.2.fill"
                    )
                }
            
            CalendarView()
                .tag(3)
                .tabItem {
                    Label(
                        R.string.localizable.tabbarCalendar(),
                        systemImage: "calendar"
                    )
                }
        }
    }
}

#Preview {
    TabbarView()
}
