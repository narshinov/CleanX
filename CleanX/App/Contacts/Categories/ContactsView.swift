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
                ForEach(model.datasource) { item in
                    NavigationLink {
                        switch item.type {
                        case .contacts:
                            ContactPickerView()
                                .toolbar(.hidden, for: .navigationBar)
                        case .duplicates:
                            Text("Duplicates")
                        case .incomplete:
                            IncompletedContactsView(model: .init(contacts: item.contacts))
                        }
                    } label: {
                        ContactsCell(model: item)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                model.requestAccess()
            }
            
        }
    }
}

#Preview {
    ContactsView()
}
