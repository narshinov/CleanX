//
//  CalendarView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 29.02.24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel = CalendarViewModel()

    @State private var isDeleteTapped = false
    
    var body: some View {
        NavigationStack {
            events
                .navigationTitle(R.string.localizable.calendarTitle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    selectAll
                    delete
                }
        }
        .confirmationDialog("", isPresented: $isDeleteTapped) {
            bottomSheet
        }
        .onAppear {
            viewModel.requestAccess()
            viewModel.fetchEvents()
        }
    }
}

private extension CalendarView {
    var events: some View {
        ScrollView {
            VStack {
                ForEach($viewModel.events) {
                    EventView(event: $0)
                        .padding(.horizontal)
                }
            }
        }
        .scrollIndicators(.never)
    }

    var selectAll: some ToolbarContent {
        var title: String {
            viewModel.isAllEventsSelected ?
            R.string.localizable.commonDeselectAll() :
            R.string.localizable.commonSelectAll()
        }
        return ToolbarItemGroup(placement: .topBarLeading) {
            Button(title) {
                viewModel.selectAllEvents()
            }
            .id(title)
            .isHidden(viewModel.events.isEmpty)
        }
    }
    
    var delete: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(R.string.localizable.commonDelete()) {
                isDeleteTapped.toggle()
            }
            .controlSize(.mini)
            .buttonStyle(.bordered)
            .isHidden(viewModel.selectedEventsCount == .zero)
        }
    }
    
    @ViewBuilder
    var bottomSheet: some View {
        let title = R.string.localizable.calendarDeleteEvent(viewModel.selectedEventsCount)
        Button(title, role: .destructive) {
            viewModel.deleteEvents()
        }
        Text(R.string.localizable.commonCancel())
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
