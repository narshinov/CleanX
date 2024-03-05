//
//  ReviewDuplicatesCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesCellModel: Hashable {
    let image: ImageResource
    var isSelected = false
}

struct ReviewDuplicatesCell: View {
    @Binding var model: ReviewDuplicatesCellModel
    
    private let cellSize: CGFloat = 50 //(UIScreen.main.bounds.width - 40)/2

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(model.image)
                .resizable()
                .scaledToFit()
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .opacity(model.isSelected ? 0.5 : .zero)
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
        .frame(width: cellSize, height: cellSize)
        
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
        model: .constant(.init(image: .monckeyMock))
    )
    .frame(width: 176, height: 176)
}

// checkmark.circle.fill
