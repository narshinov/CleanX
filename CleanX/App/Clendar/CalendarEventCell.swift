//
//  CalendarEventCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 12.03.24.
//

import SwiftUI

struct CalendarEventCell: View {

    @Binding var model: CalendarModel

    var body: some View {
        HStack {
            checkbox
            textContainer
            Spacer()
            Text(model.dateString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .fill(.background.secondary)
        }
        .onTapGesture {
            model.isSelected.toggle()
        }
    }
}

private extension CalendarEventCell {
    var checkbox: some View {
        Image(model.isSelected ? .checkmark.circleFill : .circle)
            .foregroundStyle(checkboxStyle)
    }

    var textContainer: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
                .lineLimit(1)
            Text("\(model.location): iCloud")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var checkboxStyle: LinearGradient {
        LinearGradient(
            colors: [.c165EEE, .c00C8D5],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    CalendarEventCell(
        model: .constant(
            .init(
                title: "Event",
                date: .now,
                location: "Work",
                event: .init()
            )
        )
    )
}
