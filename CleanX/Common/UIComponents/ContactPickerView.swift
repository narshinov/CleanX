//
//  ContactPickerView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import Foundation
import UIKit
import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CNContactPickerViewController
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        return CNContactPickerViewController()
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
}
