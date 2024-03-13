//
//  ContactPickerView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import UIKit
import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CNContactPickerViewController
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let vc = CNContactPickerViewController()
        vc.isEditing = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        
    }
    
}
