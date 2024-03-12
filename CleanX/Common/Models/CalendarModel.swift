//
//  CalendarModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 12.03.24.
//

import Foundation
import EventKit

struct CalendarModel: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let location: String
    let event: EKEvent
    var isSelected = true
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
}
