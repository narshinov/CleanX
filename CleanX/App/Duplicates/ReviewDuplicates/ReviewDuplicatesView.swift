//
//  ReviewDuplicatesView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 4.03.24.
//

import SwiftUI

struct ReviewDuplicatesView: View {
    
    private var data  = Array(1...20)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 90))
    ]

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("Select the items you want to delete")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    

                    LazyVGrid(columns: adaptiveColumn) {
                        ForEach(data, id: \.self) { item in
                            Text(String(item))
                                .frame(width: 90, height: 90, alignment: .center)
                                .background(.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .font(.title)
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
