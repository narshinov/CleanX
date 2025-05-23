//
//  CalendarViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 12.03.24.
//

import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    private var calendarService: CalendarServiceProtocol = CalendarService()
    
    @Published var events: [Event] = []
    @Published var isAllEventsSelected: Bool = true
    
    var selectedEventsCount: Int {
        events.filter({ $0.isSelected }).count
    }
    
    func requestAccess() {
            Task {
                do {
                     try await calendarService.requestAccess()
                } catch {
                    print(error)
                }
            }
    }
    
    func fetchEvents() {
        events = calendarService.events
    }
    
    func selectAllEvents() {
        events = events.map {
            var event = $0
            event.isSelected = !isAllEventsSelected
            return event
        }
        isAllEventsSelected.toggle()
    }
    
    func deleteEvents() {
        let selectedEvents = events.filter({ $0.isSelected }).map { $0.event }
        calendarService.deleteEvents(selectedEvents)
        events = events.filter { !$0.isSelected }
    }
}
