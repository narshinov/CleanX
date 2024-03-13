//
//  DuplicateContactCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI

struct DuplicateContactCell: View {
    
    @State private var selectContacts: [SelecteMergedContactCell.Model] = [
        .init(
            name: "Nikita",
            surname: "Bo",
            phoneNumber: "+375 29 333-21-32"
        ),
        .init(
            name: "Nikita",
            surname: "Bobasca",
            phoneNumber: "+375 29 333-21-32"
        ),
        .init(
            name: "Nikita",
            surname: "Bobasca",
            phoneNumber: "+375 29 333-21-32"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Merged Contact")
                .font(.footnote)
            MergedContactCell(
                model: .init(
                    name: "Nikita",
                    surname: "Bobasca",
                    phoneNumber: "+375 29 333-21-32"
                )
            )
            
            HStack {
                Text("Select Contacts to Merge")
                    .font(.footnote)
                Spacer()
                Button("Select All") {
                    selectAll()
                }
            }
            ForEach(selectContacts) {
                SelecteMergedContactCell(model: $0)
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
        }
    }
    
    func selectAll() {
        selectContacts = selectContacts.map {
            var new = $0
            new.isSelected = true
            return new
        }
    }
}

#Preview {
    DuplicateContactCell()
}
