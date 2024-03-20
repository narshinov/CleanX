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
    
    var contact: CNContact
    
    init(_ contact: CNContact) {
        self.contact = contact
    }
    
    func makeUIViewController(context: Context) -> CNContactViewController {
        do {
            let descriptor = CNContactViewController.descriptorForRequiredKeys()
            let editContact = try CNContactStore().unifiedContact(withIdentifier: contact.identifier, keysToFetch: [descriptor])
            return CNContactViewController(for: editContact)
        } catch {
            return CNContactViewController(forUnknownContact: contact)
        }

    }
    
    func updateUIViewController(_ uiViewController: CNContactViewController, context: Context) { }
}
