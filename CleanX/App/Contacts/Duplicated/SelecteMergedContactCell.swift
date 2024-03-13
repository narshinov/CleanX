//
//  SelecteMergedContactCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI

struct SelecteMergedContactCell: View {
    @State private var isSelected = false
    
    let model: Model
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                Text(model.phoneNumber)
            }
            Spacer()
            Checkbox(isSelected: $isSelected)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.background.secondary)
        }
    }
}

extension SelecteMergedContactCell {
    struct Model: Identifiable {
        let id = UUID()
        let name: String
        let surname: String
        let phoneNumber: String
        var isSelected: Bool = false
        
        var title: String {
            "\(name) \(surname)"
        }
    }
}

#Preview {
    SelecteMergedContactCell(
        model: .init(
            name: "Nikita",
            surname: "Bobasca",
            phoneNumber: "+375 29 333-21-32"
        )
    )
}
