//
//  CalendarService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 11.03.24.
//

import EventKit

protocol CalendarServiceProtocol {
    var events: [CalendarModel] { get }

    func requestAccess() async throws -> Bool
    func deleteEvents(_ events: [CalendarModel])
}

final class CalendarService {
    private var store = EKEventStore()
    
}

extension CalendarService: CalendarServiceProtocol {
    var events: [CalendarModel] {
        let calendar = Calendar.current
        
        var fiveYearAgoComponents = DateComponents()
        fiveYearAgoComponents.year = -4
        let fiveYearAgo = calendar.date(byAdding: fiveYearAgoComponents, to: .now)
        
        guard let fiveYearAgo else { return [] }
        let predicate = store.predicateForEvents(withStart: fiveYearAgo, end: .now, calendars: nil)
        
        let models: [CalendarModel] = store.events(matching: predicate).map ({
            .init(title: $0.title, date: $0.startDate, location: $0.calendar.title, event: $0)
        }).sorted { $0.date > $1.date }
        return models
    }
    
    func requestAccess() async throws -> Bool {
        try await store.requestFullAccessToEvents()
    }
    
    func deleteEvents(_ events: [CalendarModel]) {
        let eventsForDelete = events.filter({ $0.isSelected }).map { $0.event }
        eventsForDelete.forEach {
                try? store.remove($0, span: .thisEvent, commit: true)
        }
    }
}
