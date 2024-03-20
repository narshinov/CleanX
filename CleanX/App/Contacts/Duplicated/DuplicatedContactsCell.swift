//
//  DuplicatedContactsCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 18.03.24.
//

import SwiftUI
import Contacts

struct DuplicatedContactsCell: View {
    let model: Set<CNContact>

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text("Finded \(model.count) contacts")
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
                .fill(.background.secondary)
                
        }
    }
}

private extension DuplicatedContactsCell {
    var title: String {
        guard let contact = model.first else { return ""}
        return contact.title
    }
}

#Preview {
    DuplicatedContactsCell(
        model: .init(Set())
    )
}
