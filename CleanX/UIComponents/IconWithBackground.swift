//
//  IconWithBackground.swift
//  CleanX
//
//  Created by Nikita Arshinov on 28.02.24.
//

import SwiftUI
import SafeSFSymbols

struct IconWithBackground: View {
    
    let icon: SafeSFSymbol
    let backgroundStyle: HierarchicalShapeStyle
    let size: CGSize
    
    init(
        _ icon: SafeSFSymbol,
        backgroundStyle: HierarchicalShapeStyle = .secondary,
        size: CGSize = .init(width: 44, height: 44)
    ) {
        self.icon = icon
        self.backgroundStyle = backgroundStyle
        self.size = size
    }
    
    var body: some View {
        Image(icon)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(backgroundStyle)
                    .frame(width: size.width, height: size.height)
            }
            
    }
}

#Preview {
    IconWithBackground(.camera)
}
