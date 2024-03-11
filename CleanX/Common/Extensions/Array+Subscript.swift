//
//  Array+Subscript.swift
//  CleanX
//
//  Created by Nikita Arshinov on 11.03.24.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    subscript (safe range: ClosedRange<Int>) -> [Element] {
        Array<Int>(range).compactMap { index -> Element? in
            return indices.contains(index) ? self[index] : nil
        }
    }
}
