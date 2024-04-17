//
//  CalendarView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 29.02.24.
//

import SwiftUI

struct CalendarView: View {
    @State private var model = CalendarViewModel()
    @State private var isAllSelected = true
    @State private var isDeleteTapped = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach($model.datasource) {
                        CalendarEventCell(model: $0)
                    }
                }.padding()
            }
            .scrollIndicators(.never)
            .navigationTitle(R.string.localizable.calendarTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(isAllSelected ? R.string.localizable.commonDeselectAll() : R.string.localizable.commonSelectAll()
                    ) {
                        model.selectAll(isAllSelected)
                        isAllSelected.toggle()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(R.string.localizable.commonDelete()) {
                        isDeleteTapped.toggle()
                    }
                    .isHidden(model.selectedCount == .zero)
                    .controlSize(.mini)
                    .buttonStyle(.bordered)
                }
            }
        }
        .confirmationDialog("", isPresented: $isDeleteTapped) {
            Button(
                R.string.localizable.calendarDeleteEvent(model.selectedCount),
                role: .destructive
            ) {
                model.deleteEvents()
            }
            Text(R.string.localizable.commonCancel())
        }
        .onAppear {
            model.fechEvents()
        }
        
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
