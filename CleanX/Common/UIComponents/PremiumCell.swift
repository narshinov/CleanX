//
//  PremiumCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct PremiumCell: View {
    let title: String

    var body: some View {
        HStack {
            Image(.star.fill)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Image(.chevron.right)
            
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundGradient)
                .strokeBorder(.background.secondary, lineWidth: 2)
        }
    }
}

private extension PremiumCell {
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    PremiumCell(title: "Unlock premium features")
        .padding()
}
