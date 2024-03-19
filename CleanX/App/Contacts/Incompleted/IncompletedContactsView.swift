//
//  IncompletedContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI
import Contacts

struct IncompletedContactsView: View {
    @State private var isNoNameSelected = false
    @State private var isNoNumberSelected = false

    @State private var model: IncompletedContactsViewModel

    init(model: IncompletedContactsViewModel) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                noNameGroup
                noNumberGroup
            }.padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Incomplete contacts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
        .onAppear {
            model.fetchContacts()
        }
    }
}

extension IncompletedContactsView {
    struct Model {
        var noName: [CNContact]
        var noNumber: [CNContact]
        
        init(
            noName: [CNContact] = [],
            noNumber: [CNContact] = []
        ) {
            self.noName = noName
            self.noNumber = noNumber
        }
        
        var allCount: Int {
            noName.count + noNumber.count
        }
    }
}

private extension IncompletedContactsView {
    var noNameGroup: some View {
        Group {
            HeaderLabel(
                title: "No name contacts",
                isSelected: $isNoNameSelected
            )
            .isHidden(model.noNameDatasource.isEmpty)
            ForEach($model.noNameDatasource) { contact in
                IncompletedContactCell(model: contact)
            }
        }
    }
    
    var noNumberGroup: some View {
        Group {
            HeaderLabel(
                title: "No number contacts",
                isSelected: $isNoNumberSelected
            )
            .isHidden(model.noNumberDatasource.isEmpty)
            ForEach($model.noNumberDatasource) { contact in
                IncompletedContactCell(model: contact)
            }
        }
    }
}

#Preview {
    IncompletedContactsView(model: .init())
}
