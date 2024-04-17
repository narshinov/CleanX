//
//  ReviewDuplicatesView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isSelectionEnabled = false
    @State private var isAllSelected = false
    
    @State private var model: ReviewDuplicatesViewModel
    
    init(model: ReviewDuplicatesViewModel) {
        self.model = model
    }

    private let adaptiveColumn = [
        GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(R.string.localizable.photoVideoSelectItems())
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
//            selectButton
        }
        .onAppear {
            model.fetchImages()
        }
    }
}

private extension ReviewDuplicatesView {
    
    var deleteButtonIsHidden: Bool {
        model.selectedItemsCount == 0 ? true : false
    }
    
    var selectAllButtonText: String {
        isAllSelected ? R.string.localizable.commonDeselectAll() : R.string.localizable.commonSelectAll()
    }
    
    var selectButtonText: String {
        isSelectionEnabled ? R.string.localizable.commonCancel() : R.string.localizable.commonSelect()
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
            Button(R.string.localizable.commonDeleteCount(model.selectedItemsCount)) {
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
        .background(backgroundGradient)
    }
    
    var backgroundGradient: LinearGradient {
        let gradient = Gradient(colors: [.clear, .cGradient, .cGradient])
        return LinearGradient(
            gradient: gradient,
            startPoint: .top,
            endPoint: .center
        )
    }
}

#Preview {
    NavigationStack {
        ReviewDuplicatesView(model: .init(assets: []))
    }
}
