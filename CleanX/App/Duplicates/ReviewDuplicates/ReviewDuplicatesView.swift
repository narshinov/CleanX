//
//  ReviewDuplicatesView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesView: View {
    @ObservedObject var viewModel: ReviewDuplicatesViewModel
    
    private let adaptiveColumn = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack(alignment: .bottom) {
            content
            footer
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
    }
}

private extension ReviewDuplicatesView {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                grid
            }
            .padding(.horizontal)
            .padding(.bottom, 128)
        }
    }
    
    var header: some View {
        Text(R.string.localizable.photoVideoSelectItems())
            .font(.system(size: 24, weight: .bold))
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    var grid: some View {
        LazyVGrid(columns: adaptiveColumn, spacing: 8) {
            let size = (UIScreen.main.bounds.width - 40) / 2
            ForEach(viewModel.models.indices, id: \.self) { index in
                viewModel.models[index].image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .gridCell(isSelected: viewModel.models[index].isSelected)
                    .onTapGesture {
                        viewModel.models[index].isSelected.toggle()
                    }
            }
        }
    }
    
    var footer: some View {
        HStack {
            Spacer()
            delete
        }
        .padding(.horizontal)
        .frame(height: 128)
        .background(backgroundGradient)
    }
    
    var delete: some View {
        let title = R.string.localizable.commonDeleteCount(viewModel.selectedItemsCount)
        return Button(title) {
            viewModel.delete()
        }
        .font(.body)
        .fontWeight(.semibold)
        .controlSize(.small)
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.selectedItemsCount == 0)
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
    let model = ReviewDuplicatesViewModel(
        type: .duplicates,
        assets: [],
        coordinator: .init()
    )
    
    ReviewDuplicatesView(viewModel: model)
    
}
