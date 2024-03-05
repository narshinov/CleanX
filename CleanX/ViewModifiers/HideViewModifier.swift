//
//  HideViewModifier.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI

struct HideViewModifier: ViewModifier {
    let isHidden: Bool
    @ViewBuilder
    func body(content: Content) -> some View {
        if isHidden {
            EmptyView()
        } else {
            content
        }
    }
}
