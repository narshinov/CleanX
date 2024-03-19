//
//  DuplicatedContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI
import Contacts

struct DuplicatedContactsView: View {
    @State var model: DuplicatedContactsViewModel

    var body: some View {
        ScrollView {
            VStack {
                ForEach(model.datasource, id: \.self) {
                    DuplicatedContactsCell(model: $0)
                }
//                ForEach(model.datasource) {
//                    DuplicatedContactsCell(model: $0)
//                }
            }.padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Duplicate contacts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
        .onAppear {
            model.findDuplicates()
        }
    }
}

extension DuplicatedContactsView {
    struct Model {
        var number: [Set<CNContact>]
        var names: [Set<CNContact>]
        
        init(
            number: [Set<CNContact>] = [],
            names: [Set<CNContact>] = []
        ) {
            self.number = number
            self.names = names
        }
        
        var allCount: Int {
            number.count + names.count
        }
    }
}

#Preview {
    DuplicatedContactsView(model: .init())
}
