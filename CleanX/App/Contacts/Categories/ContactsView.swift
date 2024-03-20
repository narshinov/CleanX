//
//  ContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 29.02.24.
//

import SwiftUI

struct ContactsView: View {
    
    @State private var model = ContactsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                categoriesGroup
                Spacer()
            }
            .padding()
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                model.fetchContacts()
            }
            
        }
    }
}

private extension ContactsView {
    var categoriesGroup: some View {
        Group {
            NavigationLink {
                AllContactsView(model: .init())
            } label: {
                ContactsCell(
                    model: .init(type: .contacts, count: model.allContactsCount)
                )
            }
            
            NavigationLink {
                DuplicatedContactsView(model: .init())
            } label: {
                ContactsCell(
                    model: .init(type: .duplicates, count: model.duplicatedContactsCount)
                )
            }
            
            NavigationLink {
                IncompletedContactsView(model: .init())
            } label: {
                ContactsCell(
                    model: .init(
                        type: .incomplete,
                        count: model.incompletedContactsCount
                    )
                )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContactsView()
}
