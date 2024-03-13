//
//  MergedContactCell.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import SwiftUI

struct MergedContactCell: View {
    let model: Model

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
            Text(model.phoneNumber)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.background.secondary)
        }
    }
}

extension MergedContactCell {
    struct Model {
        let name: String
        let surname: String
        let phoneNumber: String
        
        var title: String {
            "\(name) \(surname)"
        }
    }
}

#Preview {
    MergedContactCell(
        model: .init(
            name: "Nikita",
            surname: "Bobasca",
            phoneNumber: "+375 29 333-21-32"
        )
    )
}
