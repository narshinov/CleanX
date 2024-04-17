//
//  AllContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import SwiftUI

struct AllContactsView: View {
    
    @State var model: AllContactsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.datasource) { contact in
                    NavigationLink {
                        ContactView(contact)
                            .toolbar(.visible, for: .navigationBar)
                            .navigationBarBackButtonHidden()
                            .ignoresSafeArea()
                    } label: {
                        AllContactsCell(contact: contact)
                    }.buttonStyle(.plain)
                }
            }.padding()
        }
        .navigationTitle(R.string.localizable.contactsTitle())
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            model.fetchContacts()
        }
    }
}

#Preview {
    AllContactsView(model: .init())
}
