//
//  AllContactsCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import SwiftUI
import Contacts

struct AllContactsCell: View {
    let contact: CNContact

    var body: some View {
        HStack {
            Text(contact.title)
                .font(.headline)
            Spacer()
            Image(.chevron.right)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(height: 74)
        .contentShape(Rectangle())
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .foregroundStyle(.background.secondary)
        }
        
    }
}

#Preview {
    AllContactsCell(contact: .init())
}
