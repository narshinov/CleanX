//
//  ReviewDuplicatesCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesCellModel: Identifiable {
    let id = UUID()
    let image: Image
    var isSelected = false
}

struct ReviewDuplicatesCell: View {
    @Binding var model: ReviewDuplicatesCellModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            model.image
                .resizable()
                .scaledToFit()
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
                .frame(width: 32, height: 32)
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
        model: .constant(.init(image: Image(.monckeyMock)))
    )
    .frame(width: 176, height: 176)
}

// checkmark.circle.fill
