//
//  ReviewDuplicatesCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesCell: View {
    @Binding var model: ReviewDuplicatesCellModel
    
    private let size = (UIScreen.main.bounds.width - 40) / 2

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            model.image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .contentShape(RoundedRectangle(cornerRadius: 16))
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.white)
                        .opacity(model.isSelected ? 0.3 : .zero)
                }
                .onTapGesture {
                    model.isSelected.toggle()
                }
                
            Image(.checkmark.circleFill)
                .resizable()
                .frame(width: 28, height: 28)
                .offset(x: -8, y: -8)
                .foregroundStyle(backgroundGradient)
                .isHidden(!model.isSelected)
        }
    }
}

private extension ReviewDuplicatesCell {
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    ReviewDuplicatesCell(
        model: .constant(
            .init(
                image: Image(.broomIc),
                asset: .init(),
                isSelected: true
            )
        )
    )
    .frame(width: 176, height: 176)
}
