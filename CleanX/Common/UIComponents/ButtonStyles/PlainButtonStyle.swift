//
//  PlainButtonStyle.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI

struct PlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .fontWeight(.semibold)
    }
}

