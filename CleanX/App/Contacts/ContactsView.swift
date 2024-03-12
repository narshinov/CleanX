//
//  ContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 29.02.24.
//

import SwiftUI

struct ContactsView: View {
    @State private var datasource: [ContactsCellModel] = [
        .init(type: .contacts, contactsCount: 74),
        .init(type: .duplicates, contactsCount: 32),
        .init(type: .incomplete, contactsCount: 2)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ForEach(datasource) {
                    ContactsCell(model: $0)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

#Preview {
    ContactsView()
}
