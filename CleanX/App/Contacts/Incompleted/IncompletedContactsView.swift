//
//  IncompletedContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI

struct IncompletedContactsView: View {
    
    @State private var isAllSelected = false

    @State private var model: IncompletedContactsViewModel

    init(model: IncompletedContactsViewModel) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach($model.datasource) {
                    IncompletedContactCell(model: $0)
                }
            }.padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Incomplete contacts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
        .toolbar {
            Button(isAllSelected ? "Deselect All" : "Select All") {
                model.selectAll(isAllSelected)
                isAllSelected.toggle()
            }
        }
    }
}

#Preview {
    IncompletedContactsView(model: .init(contacts: []))
}
