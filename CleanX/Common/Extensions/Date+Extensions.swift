//
//  Date+Extensions.swift
//  CleanX
//
//  Created by Никита Аршинов on 23.05.25.
//

import Foundation

extension Date {
    func toString(format: String = "d MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
}
