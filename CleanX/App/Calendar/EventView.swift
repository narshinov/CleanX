//
//  EventView.swift
//  CleanX
//
//  Created by Никита Аршинов on 23.05.25.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    let id = UUID().uuidString
    let title: String
    let date: Date
    let location: String
    let event: EKEvent
    var isSelected = true
}

struct EventView: View {
    @Binding var event: Event

    var body: some View {
        HStack {
            Checkbox(isSelected: $event.isSelected)
            container
            Spacer()
            date
        }
        .backgroundContainer()
        .onTapGesture {
            event.isSelected.toggle()
        }
    }
}

extension EventView {
    private var container: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)
                .lineLimit(1)
            Text(event.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var date: some View {
        Text(event.date.toString())
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    @Previewable @State var event = Event(
        title: "title",
        date: .now,
        location: "iCloud",
        event: .init(eventStore: .init())
    )
    EventView(event: $event)
}
