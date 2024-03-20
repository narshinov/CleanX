//
//  FillButtonStyle.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import SwiftUI

struct FillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.blue)
            }
    }
}
