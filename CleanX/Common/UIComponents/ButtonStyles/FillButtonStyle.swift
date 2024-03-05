//
//  FillButtonStyle.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI

struct FillButtonStyleView: View {
    var body: some View {
        Button("Hellow") {
            
        }.buttonStyle(FillButtonStyle())
    }
}

struct FillButtonStyle: ButtonStyle {
    var textColor: Color
    var backgroundColor: Color
    
    init(
        textColor: Color = .white,
        backgroundColor: Color = .secondary
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .fontWeight(.semibold)
            .foregroundStyle(textColor)
            .background {
                Capsule()
            }
    }
}

#Preview {
    FillButtonStyleView()
}
