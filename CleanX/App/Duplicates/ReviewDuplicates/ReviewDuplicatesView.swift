//
//  ReviewDuplicatesView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesView: View {
    
    private var data  = Array(1...20)
    
    @State private var datasource: [ReviewDuplicatesCellModel] = [
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock),
        .init(image: .monckeyMock)
    ]
    
    private let adaptiveColumn = [
        GridItem(.flexible()), GridItem(.flexible())
//        GridItem(.adaptive(minimum: (UIScreen.main.bounds.width - 40)/2))
    ]

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    Text("Select the items you want to delete")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    

                    LazyVGrid(columns: adaptiveColumn, spacing: 8) {
                        ForEach(data, id: \.self) { item in
                            Text("\(item)")
                                .frame(maxWidth:.infinity, minHeight: 90)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(.blue)
                                }
                            //ReviewDuplicatesCell(model: item)
                        }
                    }
                    
                }.padding()
            }
            HStack {
                Button("Select all") {
                    
                }
                Spacer()
                Button(action: {}, label: {
                    Label("Delete 5", systemImage: "trash.fill")
                }).buttonStyle(.borderedProminent)
            }.padding(.horizontal)
        }
        
        
        
    }
}

#Preview {
    ReviewDuplicatesView()
}
