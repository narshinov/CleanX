//
//  CalendarViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 12.03.24.
//

import Foundation

@Observable
final class CalendarViewModel {
    private let calendarService: CalendarServiceProtocol = CalendarService()
    
    var datasource: [CalendarModel] = []
    
    var selectedCount: Int {
        datasource.filter({ $0.isSelected }).count
    }
    
    func fechEvents() {
        Task {
            guard try await calendarService.requestAccess() else { return }
            datasource = calendarService.events
        }
        
    }
    
    func selectAll(_ isSelected: Bool) {
        datasource = datasource.map {
            var event = $0
            event.isSelected = !isSelected
            return event
        }
    }
    
    func deleteEvents() {
        calendarService.deleteEvents(datasource)
        datasource = datasource.filter { !$0.isSelected }
    }
}
