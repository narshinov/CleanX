//
//  MergeContactsView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import SwiftUI

struct MergeContactsView: View {
    @Environment(\.dismiss) var dismiss
    @State var model: MergeContactsViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(R.string.localizable.contactsMergeSubtitle())
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    MergeContactsCell(contact: model.mergeResultContact)
                    
                    Text(R.string.localizable.contactsDuplicatesTitle())
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding([.leading, .top])
                    ForEach(Array(model.contacts)) {
                        MergeContactsCell(contact: $0)
                    }
                }
            }
            
            Spacer()
            Divider()
            Button(R.string.localizable.contactsMerge()) {
                model.mergeContacts()
                dismiss()
            }
            .buttonStyle(FillButtonStyle())
            .padding(.top)
        }
        .padding()
        .scrollIndicators(.never)
        .navigationTitle(R.string.localizable.contactsMergeTitle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    MergeContactsView(model: .init(.init()))
}
