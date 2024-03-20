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
                    Text("Merge contact")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    MergeContactsCell(contact: model.mergeResultContact)
                    
                    Text("Duplicate contacts")
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
            Button("Merge") {
                model.mergeContacts()
                dismiss()
            }
            .buttonStyle(FillButtonStyle())
            .padding(.top)
        }
        .padding()
        .scrollIndicators(.never)
        .navigationTitle("Merge contacts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    MergeContactsView(model: .init(.init()))
}
