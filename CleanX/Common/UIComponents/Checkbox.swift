//
//  Checkbox.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI
import SafeSFSymbols

struct Checkbox: View {

    @Binding var isSelected: Bool

    var body: some View {
        Image(checkboxSFSymbol)
            .foregroundStyle(backgroundGradient)
            .controlSize(.large)
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

private extension Checkbox {
    var checkboxSFSymbol: SafeSFSymbol {
        guard isSelected else { 
            return .circle
        }
        return .checkmark.circleFill
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    Checkbox(isSelected: .constant(true))
}
