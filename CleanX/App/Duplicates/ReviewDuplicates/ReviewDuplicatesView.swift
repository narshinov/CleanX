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
    
    var deleteButtonIsHidden: Bool {
        model.selectedItems == 0 ? true : false
    }
    
    var selectAllButtonText: String {
        isAllSelected ? "Deselect all" : "Select all"
    }
    
    var selectButtonText: String {
        isSelectionEnabled ? "Cancel" : "Select"
    }
    
    var selectButton: some View {
        Button(selectButtonText) {
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
            Button(selectAllButtonText) {
                isSelectionEnabled = true
                model.selectAllTapped(isAllSelected)
                isAllSelected.toggle()
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button("Delete \(model.selectedItems)") {
                model.deleteItems()
            }
            .font(.body)
            .fontWeight(.semibold)
            .controlSize(.small)
            .buttonStyle(.borderedProminent)
            .isHidden(deleteButtonIsHidden)
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
