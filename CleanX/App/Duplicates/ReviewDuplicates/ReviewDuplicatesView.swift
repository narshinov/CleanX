//
//  ReviewDuplicatesView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesView: View {
    
    @State private var isSelectionEnabled = false
    
    @State private var datasource: [ReviewDuplicatesCellModel] = [
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock)),
        .init(image: Image(.monckeyMock))
    ]
    
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
            ForEach($datasource) { item in
                ReviewDuplicatesCell(model: item)
                    .allowsHitTesting(isSelectionEnabled)
            }
        }
    }

    var footerContainer: some View {
        HStack {
            Button("Select all") {

            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: {}, label: {
                Label("Delete 5", systemImage: "trash.fill")
                    .font(.body)
                    .fontWeight(.semibold)
            })
            
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .padding(.vertical, 32)
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
