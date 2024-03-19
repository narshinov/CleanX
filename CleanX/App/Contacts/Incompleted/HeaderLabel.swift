//
//  HeaderLabel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 18.03.24.
//

import SwiftUI

struct HeaderLabel: View {
    let title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Button(isSelected ? "Deselect All" : "Select All") {
                isSelected.toggle()
            }
        }
    }
}

#Preview {
    HeaderLabel(
        title: "No number contacts",
        isSelected: .constant(true)
    )
}
