//
//  MergeContactsResultCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import SwiftUI
import Contacts

struct MergeContactsCell: View {
    let contact: CNContact

    var body: some View {
        NavigationLink {
            ContactView(contact)
                .toolbar(.visible, for: .navigationBar)
                .navigationBarBackButtonHidden()
                .ignoresSafeArea()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                    Text(contact.phoneNumber)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(.chevron.right)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .contentShape(Rectangle())
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.background.secondary)
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    MergeContactsCell(contact: .init())
}
