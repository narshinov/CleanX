//
//  IncompletedContactCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI
import Contacts

struct IncompletedContactCell: View {
    @State private var isPresented = false

    @Binding var model: Model

    var body: some View {
        NavigationLink {
            ContactView($model.contact)
                .toolbar(.visible, for: .navigationBar)
                .navigationBarBackButtonHidden()
                .ignoresSafeArea()
        } label: {
            HStack {
                Text(model.title)
                    .font(.headline)
                Spacer()
                Checkbox(isSelected: $model.isSelected)
            }
            .padding()
            .frame(height: 74)
            .contentShape(Rectangle())
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 2)
                    .fill(.background.secondary)
                    
            }
        }.buttonStyle(.plain)
    }
}

extension IncompletedContactCell {
    struct Model: Identifiable {
        let id = UUID()
        var contact: CNContact
        var isSelected: Bool = false
        
        var title: String {
            if !name.isEmpty {
                return name
            } else if !phone.isEmpty {
                return phone
            } else {
                return ""
            }
        }
        
        private var name: String {
            CNContactFormatter.string(
                from: contact,
                style: .fullName
            ).orEmpty
        }
        
        private var phone: String {
            let numbers = contact.phoneNumbers.compactMap {
                $0.value.stringValue
            }
            return numbers.first.orEmpty
        }
    }
}

#Preview {
    IncompletedContactsView(model: .init())
}
