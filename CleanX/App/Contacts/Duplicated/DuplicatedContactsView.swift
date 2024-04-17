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
                ForEach(model.datasource, id: \.self) { contacts in
                    NavigationLink {
                        MergeContactsView(model: .init(contacts))
                    } label: {
                        DuplicatedContactsCell(model: contacts)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .scrollIndicators(.never)
        .navigationTitle(R.string.localizable.contactsDuplicatesTitle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
        .onAppear {
            model.findDuplicates()
        }
    }
}

#Preview {
    DuplicatedContactsView(model: .init())
}
