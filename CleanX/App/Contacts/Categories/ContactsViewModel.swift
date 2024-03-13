//
//  ContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import Foundation
import Contacts

@Observable
final class ContactsViewModel {
    
    private let contactsService: ContactsServiceProtocol = ContactsService()
    
    private var incompleteContacts: [CNContact] = []
    
    var datasource: [ContactsCell.Model] {
        [
            .init(type: .contacts, contacts: []),
            .init(type: .duplicates, contacts: []),
            .init(type: .incomplete, contacts: incompleteContacts)
        ]
    }
    
    func requestAccess() {
        Task {
            let isAvailable = await contactsService.requestAccess()
            guard isAvailable else { return }
            contactsService.findIncompleteContacts { [weak self] in
                self?.incompleteContacts = $0
            }
        }
    }
}
