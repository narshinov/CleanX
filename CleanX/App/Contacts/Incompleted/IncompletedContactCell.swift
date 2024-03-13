//
//  IncompletedContactCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI

struct IncompletedContactCell: View {
    
    @Binding var model: Model

    var body: some View {
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
    }
}

extension IncompletedContactCell {
    struct Model: Identifiable {
        let id = UUID()
        let title: String
        var isSelected: Bool = false
    }
}

#Preview {
    IncompletedContactCell(
        model: .constant(.init(title: "Bob"))
    )
}
