//
//  IncompletedContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI
import Contacts

struct IncompletedContactsView: View {
    @State private var isAllSelected = false

    @State private var model: IncompletedContactsViewModel

    init(model: IncompletedContactsViewModel) {
        self.model = model
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach($model.datasource) {
                        IncompletedContactCell(model: $0)
                    }
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 128)
            }
            .scrollIndicators(.never)
            footerContainer
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle("Incomplete contacts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
        .toolbar {
            selectAllButton
        }
        .onAppear {
            model.fetchContacts()
        }
    }
}

private extension IncompletedContactsView {
    var selectAllButton: some View {
        Button(isAllSelected ? "Deselect All" : "Select All") {
            isAllSelected.toggle()
            model.selectAll(isAllSelected)
        }
    }
    
    var footerContainer: some View {
        Group {
            Button("Delete \(model.selectedContactsCount) contacts") {
                model.deleteContacts()
            }
            .padding(.horizontal)
            .buttonStyle(FillButtonStyle())
        }
        .frame(maxWidth: .infinity, minHeight: 128)
        .background(.white)
        .mask(backgroundGradient)
        .isHidden(model.selectedContactsCount == .zero)
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, .white, .white, .white, .white],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    IncompletedContactsView(model: .init())
}
