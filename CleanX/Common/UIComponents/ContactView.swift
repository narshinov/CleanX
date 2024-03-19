//
//  ContactView.swift
//  CleanX
//
//  Created by Nikita Arshinov on 18.03.24.
//

import SwiftUI
import Contacts
import ContactsUI

struct ContactView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CNContactViewController
    
    @Binding var contact: CNContact
    
    init(_ contact: Binding<CNContact>) {
        self._contact = contact
    }
    
    func makeUIViewController(context: Context) -> CNContactViewController {
        do {
            let descriptor = CNContactViewController.descriptorForRequiredKeys()
            let editContact = try CNContactStore().unifiedContact(withIdentifier: contact.identifier, keysToFetch: [descriptor])
            return CNContactViewController(for: editContact)
        } catch {
            return CNContactViewController()
        }

    }
    
    func updateUIViewController(_ uiViewController: CNContactViewController, context: Context) { }
}
