//
//  BackgroundContainer.swift
//  CleanX
//
//  Created by Никита Аршинов on 23.05.25.
//

import SwiftUI

struct BackgroundContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .contentShape(Rectangle())
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 2)
                    .fill(.background.secondary)
            }
    }
}

extension View {
    func backgroundContainer() -> some View {
        modifier(BackgroundContainer())
    }
}
