//
//  View+Extension.swift
//  CleanX
//
//  Created by Nikita Arshinov on 5.03.24.
//

import SwiftUI

extension View {
    func isHidden(_ isHidden: Bool) -> some View {
        ModifiedContent(
            content: self,
            modifier: HideViewModifier(isHidden: isHidden)
        )
    }
}
