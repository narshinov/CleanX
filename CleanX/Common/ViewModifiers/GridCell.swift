//
//  GridCell.swift
//  CleanX
//
//  Created by Никита Аршинов on 25.05.25.
//

import SwiftUI

struct GridCell: ViewModifier {
    var isSelected: Bool

    func body(content: Content) -> some View {
        let base = RoundedRectangle(cornerRadius: 16)
        ZStack(alignment: .bottomTrailing) {
            content
                .contentShape(base)
                .clipShape(base)
                .overlay {
                    base
                        .foregroundStyle(.white)
                        .opacity(isSelected ? 0.3 : .zero)
                }
            checkmark
        }
    }
}

private extension GridCell {
    var checkmark: some View {
        Image(.checkmark.circleFill)
            .resizable()
            .frame(width: 28, height: 28)
            .offset(x: -8, y: -8)
            .foregroundStyle(backgroundGradient)
            .isHidden(!isSelected)
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension View {
    func gridCell(isSelected: Bool) -> some View {
        modifier(GridCell(isSelected: isSelected))
    }
}
