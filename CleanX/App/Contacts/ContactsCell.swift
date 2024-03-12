//
//  ContactsCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 12.03.24.
//

import SwiftUI

enum ContactsCategoryType {
    case contacts
    case duplicates
    case incomplete
    
    var title: String {
        switch self {
        case .contacts:
            return "Contacts"
        case .duplicates:
            return "Duplicates"
        case .incomplete:
            return "Incomplete Contacts"
        }
    }
    
    var subtitle: String {
        switch self {
        case .contacts:
            ""
        case .duplicates:
            "Names - Numbers - Emails"
        case .incomplete:
            "No Name - No Number"
        }
    }
}

struct ContactsCellModel: Identifiable {
    let id = UUID()
    let type: ContactsCategoryType
    var contactsCount: Int
}

struct ContactsCell: View {
    
    let model: ContactsCellModel
    
    var body: some View {
        HStack {
            textContainer
            Spacer()
            trailingContainer
        }
        .padding()
        .frame(height: 74)
        .contentShape(Rectangle())
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
                
        }
    }
}

private extension ContactsCell {
    var textContainer: some View {
        VStack(alignment: .leading) {
            Text(model.type.title)
                .font(.headline)
            Text(model.type.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .isHidden(model.type.subtitle.isEmpty)
        }
    }
    
    var trailingContainer: some View {
        Group {
            Text("\(model.contactsCount)")
            Image(.chevron.right)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    ContactsCell(
        model: .init(
            type: .contacts,
            contactsCount: 75
        )
    )
}
