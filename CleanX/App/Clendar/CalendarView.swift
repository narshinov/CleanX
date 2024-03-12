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
                }.padding(.horizontal)
            }
            .scrollIndicators(.never)
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(isAllSelected ? "Deselect All" : "Select All") {
                        model.selectAll(isAllSelected)
                        isAllSelected.toggle()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Delete") {
                        isDeleteTapped.toggle()
                    }
                    .isHidden(model.selectedCount == .zero)
                    .controlSize(.mini)
                    .buttonStyle(.bordered)
                }
            }
        }
        .confirmationDialog("", isPresented: $isDeleteTapped) {
            Button("Delete \(model.selectedCount) event", role: .destructive) {
                model.deleteEvents()
            }
            Text("Cancel")
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
