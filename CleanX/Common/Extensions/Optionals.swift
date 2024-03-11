//
//  Optionals.swift
//  CleanX
//
//  Created by Nikita Arshinov on 11.03.24.
//

import Foundation
import SwiftUI
import UIKit

extension Optional where Wrapped == Image {
    var orEmpty: Image {
        self ?? Image(uiImage: .init())
    }
}

extension Optional where Wrapped == UIImage {
    var orEmpty: UIImage {
        self ?? UIImage()
    }
}

extension Optional where Wrapped == CIImage {
    var orEmpty: CIImage {
        self ?? CIImage()
    }
}

extension Optional where Wrapped == Int {
    var orZero: Int {
        self ?? 0
    }
}

extension Optional {
    var orEmpty: String {
        if let data = self as? String {
            return data
        } else if let data = self as? Int {
            return "\(data)"
        }

        return ""
    }
}
