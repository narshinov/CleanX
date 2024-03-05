//
//  ReviewDuplicatesView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesView: View {
    @State private var isSelectionEnabled = false
    @State private var isAllSelected = false
    
    @State private var model = ReviewDuplicatesViewModel()

    private let adaptiveColumn = [
        GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Select the items you want to delete")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    gridContainer
                }
                .padding(.horizontal)
                .padding(.bottom, 128)
            }
            footerContainer
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            selectButton
        }
    }
}

private extension ReviewDuplicatesView {
    
    var selectButton: some View {
        Button(isSelectionEnabled ? "Cancel" : "Select") {
            isSelectionEnabled.toggle()
        }
        .controlSize(.mini)
        .buttonStyle(.bordered)
    }
    
    var gridContainer: some View {
        LazyVGrid(columns: adaptiveColumn, spacing: 8) {
            ForEach($model.datasource) { item in
                ReviewDuplicatesCell(model: item)
                    .allowsHitTesting(isSelectionEnabled)
            }
        }
    }

    var footerContainer: some View {
        HStack {
            Button(isAllSelected ? "Deselect all" : "Select all" ) {
                isSelectionEnabled = true
                isAllSelected ? model.deselectAll() : model.selectAll()
                isAllSelected.toggle()
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: {}, label: {
                Label("Delete \(model.selectedItems)", systemImage: "trash.fill")
                    .font(.body)
                    .fontWeight(.semibold)
            })
            .buttonStyle(.borderedProminent)
            .isHidden(model.selectedItems == 0 ? true : false)
        }
        .padding(.horizontal)
        .frame(height: 128)
        .background(.white)
        .mask(backgroundGradient)
        
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
    NavigationStack {
        ReviewDuplicatesView()
    }
}
